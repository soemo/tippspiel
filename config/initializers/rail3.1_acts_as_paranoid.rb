# Fix für Rails3.1 ~> https://github.com/goncalossilva/rails3_acts_as_paranoid/issues/40

module ParanoidValidations
  class UniquenessWithoutDeletedValidator
    def mount_sql_and_params(klass, table_name, attribute, value)
      column = klass.columns_hash[attribute.to_s]

      operator = if value.nil?
                   "IS ?"
                 elsif column.text?
                   value = column.limit ? value.to_s.mb_chars[0, column.limit] : value.to_s
                   "#{klass.connection.case_sensitive_equality_operator} ?"
                 else
                   "= ?"
                 end

      sql_attribute = "#{table_name}.#{klass.connection.quote_column_name(attribute)}"

      if value.nil? || (options[:case_sensitive] || !column.text?)
        sql = "#{sql_attribute} #{operator}"
      else
        sql = "LOWER(#{sql_attribute}) = LOWER(?)"
      end

      [sql, [value]]
    end
  end
end
