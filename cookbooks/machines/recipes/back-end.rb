# Note: this does not work
class Chef
  class Recipe
    def back_end(name, options = {}, &overrides)
      machine "be-#{name}" do
        tag 'be'
      end
    end
  end
end
