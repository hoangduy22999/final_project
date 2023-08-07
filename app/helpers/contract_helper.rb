module ContractHelper
  def salary_decorator(salary)
    str = ''
    salary.to_s.reverse.split('').each.with_index(1) {|c, index| str += (index % 3 == 0)  ? "#{c}." : c}
    "$ #{str.reverse}"
  end

  def contract_type_options
    Contract.contract_types.keys.each_with_object([["-- #{I18n.t('form_selects.contract_type')} --", '']]) do |type, object|
      object << [Contract.human_enum_name(:contract_type, type), type]
    end
  end

  def contract_status_options
    Contract.statuses.keys.each_with_object([["-- #{I18n.t('form_selects.status')} --", '']]) do |status, object|
      object << [Contract.human_enum_name(:status, status), status]
    end
  end
end