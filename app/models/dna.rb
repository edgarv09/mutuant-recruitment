class Dna < ApplicationRecord
  extend Forwardable
  def_delegators :MutantDna, :dna_identifier
  validates :dna, presence: true
  #validates_uniqueness_of :identifier
  #validates_with Validator::DnaIdentifier, fields [:identifier]

  before_create :dna_identifier

  scope :mutant, -> { where(is_mutant: true) }
  scope :human, -> { where(is_mutant: false) }

  enum type: array_to_enum_hash(DnaTypes::TYPES), _suffix: true

  def types
    @types ||= DnaTypes.new(read_attribute(:types))
  end

  def self.dna_identifier(dna)
    Digest::SHA512.hexdigest(dna.to_s)
  end

  def self.find_by_dna(dna)
    where(identifier: dna_identifier(dna)).take
  end

  private

  def dna_identifier
    p "dna_identifier calcular #{Digest::SHA512.hexdigest(dna.to_s)}"
    self.identifier = self.class.dna_identifier(dna)
  end

end