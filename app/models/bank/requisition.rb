class Bank::Requisition
  include Bank::Connection

  attr_reader :id, :link, :reference_id, :institution_id

  def initialize(id:, **attrs)
    @id = id
    @link = attrs[:link]
    @account_ids = attrs[:accounts]
    @reference_id = attrs[:reference]
    @institution_id = attrs[:institution_id]
  end

  def accounts
    raise "Cannot fetch accounts without account_ids" unless @account_ids.present?

    @accounts ||= @account_ids.map { Bank::Account.find it }
  end

  def delete
    connection
      .delete("requisitions/#{id}/")
      .body
  end

  class << self
    def all
      connection
        .get("requisitions/")
        .body
        .fetch(:results)
        .map { new(**it) }
    end

    def find(id)
      connection
        .get("requisitions/#{id}/")
        .body
        .then { new(**it) }
    end

    def create(institution,
               reference_id: SecureRandom.uuid,
               redirect_url: "http://localhost:3000")
      connection
        .post("agreements/enduser/", {
          institution_id: institution.id,
          max_historical_days: institution.transaction_total_days,
          access_valid_for_days: institution.max_access_valid_for_days,
          access_scope: %w[balances details transactions]
        })
        .body => { id: agreement_id }

      connection
        .post("requisitions/", {
          institution_id: institution.id,
          agreement: agreement_id,
          reference: reference_id,
          redirect: redirect_url,
          user_language: "EN"
        })
        .body
        .then { new(**it) }
    end
  end
end
