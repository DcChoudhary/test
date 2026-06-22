require_relative './../../string_q/reverse_word_two_pointer'

describe StringQ::ReverseWordTwoPointer do
  describe '#reverse_words' do
    it 'returns an empty string when input is empty' do
      expect(subject.reverse_words('')).to eq('')
    end

    it 'returns an empty string when the input is only whitspaces' do
      expect(subject.reverse_words(' ')).to eq('')
    end

    it 'handle the single word character string' do
      expect(subject.reverse_words('a')).to eq('a')
    end

    it 'reverse the number string' do
      expect(subject.reverse_words('123 45')).to eq('45 123')
    end

    it 'correctly reverses emoji characters treated as words' do
      expect(subject.reverse_words(' 🙂 🙃 ')).to eq('🙃 🙂')
    end

    it 'treats adjacent spaces as a single delimiter' do
      expect(subject.reverse_words(' a   lot  of  spaces ')).to eq('spaces of lot a')
    end

    it 'returns the same string when all the words are identical' do
      expect(subject.reverse_words('go go go go')).to eq('go go go go')
    end
  end
end
