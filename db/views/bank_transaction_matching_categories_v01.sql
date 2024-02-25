SELECT bank_transactions.id AS bank_transaction_id,
       rules.id             AS rule_id,
       categories.id        AS category_id
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
LEFT JOIN categories ON rules.category_id = categories.id;
