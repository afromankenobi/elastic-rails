module Elastic::Nodes
  class Nested < Base
    def self.build(_path, _child)
      new.tap do |node|
        node.path = _path
        node.child = _child
      end
    end

    attr_accessor :path, :child

    def traverse(&_block)
      super
      @child.traverse(&_block)
    end

    def clone
      prepare_clone super, @child.clone
    end

    def simplify
      new_child = @child.simplify
      if new_child.is_a? Nested
        prepare_clone(super, new_child.child).tap do |clone|
          clone.path = "#{clone.path}.#{new_child.path}"
        end
      else
        prepare_clone super, new_child
      end
    end

    def render(_options = {})
      path = @path
      path = "#{_options[:query_path]}.#{path}" if _options.key? :query_path

      {
        "nested" => {
          "path" => path,
          "query" => @child.render(_options.merge(query_path: path))
        }
      }
    end

    private

    def prepare_clone(_clone, _child)
      _clone.path = @path
      _clone.child = _child
      _clone
    end
  end
end
