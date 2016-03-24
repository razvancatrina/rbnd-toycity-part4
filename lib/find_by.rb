class Module
  def create_finder_methods(*attributes)
     attributes.each do |attribute|
      self.instance_eval(
      	"def find_by_#{attribute}(param)
      		product = self.all.select{ |item| item.#{attribute} == param}.first
      		return product
      	end"
      )
    end
  end
end
