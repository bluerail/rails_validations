# Check digit for BSN, but see if we can make this more generic
#class ElevenProofValidator < ActiveModel::EachValidator
#  # The eleven-proof of a BSN is as follows:
#  # Given: BSN presented as ABCDEFGHI with length is 9:
#  # 9xA+8xB+7xC+6xD+5xE+4xF+3xG+2xH-1xI (caveat: the minus!)
#
#  def validate_each(record, attribute, value)
#    return if value.to_s.empty?
#
#    total = 0
#    if value.to_s.length == 9
#      8.times { |x| total += value[x].to_i * (9-x) }
#      total -= value[8].to_i
#    end
#
#    record.errors.add(attribute, I18n.t('errors.messages.eleven_proof_error')) if total.modulo(11)!=0 || value.length != 9
#  end
#end
