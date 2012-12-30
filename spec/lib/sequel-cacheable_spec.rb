require 'spec_helper'

class RedisModel < Sequel::Model(:spec)
end

class MemcacheModel < Sequel::Model(:spec)
  plugin :cacheable, MemcacheCli
end

class DalliModel < Sequel::Model(:spec)
  plugin :cacheable, DalliCli
end

QueenCheck::Arbitrary(Float, Fixnum.arbitrary.gen)
QueenCheck::Arbitrary(String, QueenCheck::Gen.quadratic(200).bind { | length |
    if length.zero?
      QueenCheck::Gen.unit("")
    else
      QueenCheck::Gen.rand.resize(1, length).fmap { | r |
        str = []
        r.times { str << QueenCheck::Alphabet.arbitrary.gen.value(0)[0] }
        str.join()
      }
    end
  })

describe Sequel::Plugins::Cacheable do
  QueenCheck("Generate Test Datas",
  String, Fixnum, Float, Bignum, Boolean) do |string, fixnum, float, bignum, boolean|
    float = float * 1.0 / (10 ** (rand(4) + 1))
    RedisModel.create({
      :string => string,
      :integer => fixnum,
      :float => float,
      :bignum => bignum,
      :numeric => BigDecimal(float.to_s),
      :date => Date.today,
      :datetime => DateTime.now,
      :time => Time.now,
      :bool => boolean
    })
    true
  end

  context "NoNameClass" do
    before {
      @model = Class.new(Sequel::Model(:rspec))
    }

    it "should raise NoMethodError if the delete method is not found" do
      proc {
        @model.plugin :cacheable, 1
      }.should raise_error(NoMethodError)
    end
  end

  context MemcacheModel do
    subject { MemcacheModel }

    its("cache_store") { should == MemcacheCli }
    its("cache_store_type.set_with_ttl?") { should be_true }
    its("cache_store_type.delete_method") { should == :delete }
    its("cache_options.ttl") { should == 3600 }
    its("cache_options.ignore_exceptions") { should be_false }
    its("cache_options.pack_lib") { should == MessagePack }

    describe "cache control" do
      it "set" do
        MemcacheModel.cache_set('MemcacheModel::test', MemcacheModel[1])
      end

      it "get" do
        cache = MemcacheModel.cache_get('MemcacheModel::test')
        cache.should == MemcacheModel[1]
      end

      it "del" do
        MemcacheModel.cache_del('MemcacheModel::test')
        MemcacheModel.cache_get('MemcacheModel::test').should be_nil
      end
    end

    describe "act as cache" do
      context "Model[40]" do
        before do
          @obj = MemcacheModel[40]
        end

        it "stored cache" do
          MemcacheModel.cache_get(@obj.cache_key).should == @obj
        end

        it "restoreble cache data" do
          cached = MessagePack.unpack(MemcacheCli.get(@obj.cache_key))
          cached['string'].should == @obj.string
          Time.at(cached['time'][0], cached['time'][1]).should === @obj.time
        end

        it "update cache data" do
          @obj.string = 'modified++'
          cached = MessagePack.unpack(MemcacheCli.get(@obj.cache_key))
          cached['string'].should_not == @obj.string
          @obj.save
          cached = MessagePack.unpack(MemcacheCli.get(@obj.cache_key))
          cached['string'].should == @obj.string
        end

        it "delete cache data" do
          cache_key = @obj.cache_key; @obj.delete
          MemcacheCli.get(cache_key).should be_nil
          MemcacheModel[40].should be_nil
        end

        it "destroy cache data" do
          @obj = MemcacheModel[41]
          cache_key = @obj.cache_key; @obj.destroy
          MemcacheCli.get(cache_key).should be_nil
          MemcacheModel[41].should be_nil
        end
      end
    end

    describe "query cache" do
      it "get" do
        MemcacheModel.all.should == MemcacheModel.all
      end

      pending "not supported query cache on Memcache Client"
    end
  end

  context DalliModel do
    subject { DalliModel }

    its("cache_store") { should == DalliCli }
    its("cache_store_type.set_with_ttl?") { should be_true }
    its("cache_store_type.delete_method") { should == :delete }
    its("cache_options.ttl") { should == 3600 }
    its("cache_options.ignore_exceptions") { should be_false }
    its("cache_options.pack_lib") { should == MessagePack }

    describe "cache control" do
      it "set" do
        DalliModel.cache_set('DalliModel::test', DalliModel[1])
      end

      it "get" do
        cache = DalliModel.cache_get('DalliModel::test')
        cache.should == DalliModel[1]
      end

      it "del" do
        DalliModel.cache_del('DalliModel::test')
        DalliModel.cache_get('DalliModel::test').should be_nil
      end
    end

    describe "act as cache" do
      context "Model[40]" do
        before do
          @obj = DalliModel[40]
        end

        it "stored cache" do
          DalliModel.cache_get(@obj.cache_key).should == @obj
        end

        it "restoreble cache data" do
          cached = MessagePack.unpack(DalliCli.get(@obj.cache_key))
          cached['string'].should == @obj.string
          Time.at(cached['time'][0], cached['time'][1]).should === @obj.time
        end

        it "update cache data" do
          @obj.string = 'modified++'
          cached = MessagePack.unpack(DalliCli.get(@obj.cache_key))
          cached['string'].should_not == @obj.string
          @obj.save
          cached = MessagePack.unpack(DalliCli.get(@obj.cache_key))
          cached['string'].should == @obj.string
        end

        it "delete cache data" do
          cache_key = @obj.cache_key; @obj.delete
          DalliCli.get(cache_key).should be_nil
          DalliModel[40].should be_nil
        end

        it "destroy cache data" do
          @obj = DalliModel[41]
          cache_key = @obj.cache_key; @obj.destroy
          DalliCli.get(cache_key).should be_nil
          DalliModel[41].should be_nil
        end
      end
    end

    describe "query cache" do
      it "get" do
        DalliModel.all.should == DalliModel.all
      end

      pending "not supported query cache on Dalli Client"
    end
  end

  context RedisModel do
    subject { RedisModel }

    it "should raise LoadError if the plugin is not found" do
      proc{ RedisModel.plugin :something_or_other}.should raise_error(LoadError)
    end

    its("columns") { should == [:id,:string,:integer,:float,:bignum,:numeric,:date,:datetime,:time,:bool] }

    its("plugins") {
      should_not include(Sequel::Plugins::Cacheable)
      RedisModel.plugin :cacheable, RedisCli
      should include(Sequel::Plugins::Cacheable)
    }

    its("cache_store") { should == RedisCli }
    its("cache_store_type.set_with_ttl?") { should be_false }
    its("cache_store_type.delete_method") { should == :del }
    its("cache_options.ttl") { should == 3600 }
    its("cache_options.ignore_exceptions") { should be_false }
    its("cache_options.pack_lib") { should == MessagePack }

    describe "cache control" do
      it "set" do
        RedisModel.cache_set('RedisModel::test', RedisModel[1])
      end

      it "get" do
        RedisModel.cache_get('RedisModel::test').should == RedisModel[1]
      end

      it "del" do
        RedisModel.cache_del('RedisModel::test')
        RedisModel.cache_get('RedisModel::test').should be_nil
      end
    end

    describe "act as cache" do
      context "Model[50]" do
        before do
          @obj = RedisModel[50]
        end

        it "unstored cache on new" do
          before_count = RedisCli.keys.length
          RedisModel.new({:string => 'test'})
          RedisCli.keys.length.should == before_count
        end

        it "stored cache" do
          RedisModel.cache_get(@obj.cache_key).should == @obj
        end

        it "restoreble cache data" do
          cached = MessagePack.unpack(RedisCli.get(@obj.cache_key))
          cached['string'].should == @obj.string
          Time.at(cached['time'][0], cached['time'][1]).should === @obj.time
        end

        it "update cache data" do
          @obj.string = 'modified++'
          cached = MessagePack.unpack(RedisCli.get(@obj.cache_key))
          cached['string'].should_not == @obj.string
          @obj.save
          cached = MessagePack.unpack(RedisCli.get(@obj.cache_key))
          cached['string'].should == @obj.string
        end

        it "delete cache data" do
          @obj.delete
          RedisCli.keys(@obj.cache_key).should == []
          RedisModel[50].should be_nil
        end

        it "destroy cache data" do
          @obj = RedisModel[51]
          @obj.delete
          RedisCli.keys(@obj.cache_key).should == []
          RedisModel[51].should be_nil
        end
      end
    end

    describe "query cache" do
      it "set and get" do
        RedisModel.clear_query_cache
        models = RedisModel.limit(3).all
        cache_key = RedisCli.keys('RedisModel::Query::*')[0]
        RedisModel.cache_get(cache_key).should == models
      end

      it "clear on update" do
        RedisModel.clear_query_cache
        RedisModel.all
        cache_key = RedisCli.keys('RedisModel::Query::*')
        cache_key.should_not be_empty
        RedisModel[2].save({:string => 'test++'})
        RedisCli.keys('RedisModel::Query::*').should be_empty
      end

      it "clear on delete" do
        RedisModel.clear_query_cache
        RedisModel.all
        cache_key = RedisCli.keys('RedisModel::Query::*')
        cache_key.should_not be_empty
        RedisModel[2].delete
        RedisCli.keys('RedisModel::Query::*').should be_empty
      end

      it "cacheout rescue" do
        RedisModel.clear_query_cache
        caches = RedisModel.limit(20).all
        cache_key = RedisCli.keys('RedisModel::Query::*')[0]
        cache = caches[rand(caches.length-1)]
        RedisModel.cache_del(cache.cache_key)
        RedisModel.cache_get(cache_key).should == caches
      end
    end
  end
end
