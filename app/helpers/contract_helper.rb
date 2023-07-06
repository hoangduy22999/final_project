module ContractHelper
  def salary_decorator(salary)
    str = ''
    salary.to_s.reverse.split('').each.with_index(1) {|c, index| str += (index % 3 == 0)  ? "#{c}." : c}
    "$ #{str.reverse}"
  end

  def contract_type_options
    Contract.contract_types.keys.each_with_object([['-- Choose Type --', '']]) do |type, object|
      object << [type.titleize, type]
    end
  end
end