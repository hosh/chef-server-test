# Note: this does not work
class Chef
  class Recipe
    def front_end(name, options = {}, &overrides)
      machine "fe-#{name}" do
        tag 'fe'
        instance_eval(&overrides)
      end
    end
  end
end
