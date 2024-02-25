SELECT bank_transactions.id AS bank_transaction_id,
       bank_transactions.rule_id AS bank_transaction_rule_id,
       bank_transactions.category_id AS bank_transaction_category_id,
       rules.id        AS matching_rule_id,
       categories.id   AS matching_category_id
FROM bank_transactions
LEFT JOIN rules ON (
        (rules.date IS NULL OR bank_transactions.date = rules.date)
    AND (rules.amount IS NULL OR bank_transactions.amount = rules.amount)
    AND (rules.currency IS NULL OR bank_transactions.currency = rules.currency)
    AND (rules.party IS NULL
            OR (rules.strictness = 'strict' AND lower(bank_transactions.party) = lower(rules.party))
            OR (rules.strictness = 'lenient' AND bank_transactions.party LIKE '%' || rules.party || '%'))
    AND (rules.description IS NULL
            OR (rules.strictness = 'strict' AND lower(bank_transactions.description) = lower(rules.description))
            OR (rules.strictness = 'lenient' AND bank_transactions.description LIKE '%' || rules.description || '%'))
)
LEFT JOIN categories ON rules.category_id = categories.id
