module Elastic::Results
  class GroupedResult < Base
    include Enumerable

    def initialize(_groups)
      @groups = _groups.to_a
    end

    def each(&_block)
      @groups.map { |g| group_as_pair g }.each(&_block)
    end

    def last
      return nil if @groups.count == 0
      group_as_pair @groups.last
    end

    def count
      @groups.count
    end

    def group_at(_idx)
      @groups[_idx]
    end

    def traverse(&_block)
      super
      @groups.each { |h| h.traverse(&_block) }
    end

    private

    def group_as_pair(_group)
      [_group.keys, _group.as_value]
    end
  end
end