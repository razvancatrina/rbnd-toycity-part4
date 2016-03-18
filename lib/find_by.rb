class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    if self.name == "Product"
     attributes.each do |attribute|
      self.instance_eval(
      	"def find_by_#{attribute}(brand_name)
      		product = Product.all.select{ |item| item.#{attribute} == brand_name}.first
      		return product
      	end"
      )
    end
    end
  end
end
