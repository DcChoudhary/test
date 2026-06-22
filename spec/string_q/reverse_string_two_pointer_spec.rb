require_relative '../../string_q/reverse_string_two_pointer'

describe StringQ::ReverseStringTwoPointer do
  context '#reverse_string' do
    it 'reverse the given string' do
      expect(subject.reverse_string('abcd')).to eq('dcba')
    end

    it 'handle the empty string' do
      expect(subject.reverse_string('')).to eq('')
    end

    it 'handle the single character string' do
      expect(subject.reverse_string('a')).to eq('a')
    end

    it 'should reverse the number string' do
      expect(subject.reverse_string('12345')).to eq('54321')
    end

    it 'should reverse the emoji' do
      expect(subject.reverse_string('🙂🙃')).to eq('🙃🙂')
    end

    it 'should hanlde the lower case and upper case string' do
      expect(subject.reverse_string('heLLo')).to eq('oLLeh')
    end

    it 'should revers the string with spaces' do
      expect(subject.reverse_string('Hello World')).to eq('dlroW olleH')
    end
  end
end
