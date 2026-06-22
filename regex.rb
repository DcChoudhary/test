Q1 

"foo 123 bar 456".scan(/\d+/) #=> ['123', '456'] extract only numbers from the string

Q2 

"hello world from ruby".gsub(/\w+/) { |w| w.capitlize }

Q3 

# Group captured
"https://example.com/path".match(/(https):\/\/([^\/]+)/).captures #=> ["https", "example.com"]

# Named captured groups
"https://example.com/path".match(/(?<procotocl>https):\/\/(?<domain>[^\/]+)/).named_captures #=> { "protocal" => "https", "domain"=> "example.com"}

Q4

"1 cat, 2 dogs, 3 birds".sub(/\d+/, 'one')

Q5

"abc123" =~ /\d/ #=> 3. return index for the first digit/number

Q6

/\A#\h{6}\z/

/#[a-fA-F0-9]{6}/

/\A#[a-f0-9]{3}(?:[a-f0-9]{3})?\z/i


Q7

"+91 (98765) 43210".gsub(/[^0-9]/, '')

"+91 (98765) 43210".gsub(/\D/, '')


Q8

('hello_world').match?(/\A[a-z_]+\z/)

Q9

"Alice went to Paris with Bob".scan(/\b[A-Z][a-z]*+/)

Q10

/[[:punct]]/

Q11

"123".match?(/\A\d+\z/) #=> true
"123.4".match?(/\A\d+\z/) #=> false

Q12

"<b>Bold</b> and <i>italic</i>".match(/<.+?>/)[0]


Q13

"the the".match(/(\w+)\s\1/)

Q14

"pass".match?(/.{8}/)


Q15

"+1-800-555-1234".match?(/\A(\+\d-)?\d{3}-\d{3}-\d{4}\z/)



Q.16

'12345'.match?(/\A\d+\z/) #=> true
'1234\n123'.match?(/\A\d+\z/) # => false
'abcd1234'.match?(/\A\d+\z/)  #=> false

# Use the /A \z for the string it will consider the whole string


Q. 17

"once upon a time, on the moon".sacn(/\bon\b/)

# use the \b word boundary to only macth the whole on


Q. 18
log = "Info: started\nError: disk full\nInfo: ok\nError: timeout"

log.scan(/^Error.+$/)

# we use scan becasue it return all the occurences
 
Q. 19

"valid\nevil".match?(/^\w+$/) #=> true becasue we have ^ $ which consider the line not the whole string

"valid\nevil".match?(/\A\w+\z/) #=> false


Q. 20

"Hello world".scan(/\AHello/) #=> Hello 
# we only uses \A not the /z. becasue we want to find the Hello from the start of the string, we don't care

Q21

"2026-06-20".match(/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/).named_captures

Q22

"John smith".gsub(/(\w+) (\w+)/, '\2 \1')


Q23

"this the the quick".match(/\b(\w+)\s+\1\b/i)

Q24

"repo-rt_final.pdf".match(/\A(.+).(\w+)\z/).captures

Q25

"a=1, b=2, c=3".scan(/(\w+)=(\w+)/)

Q26

"2026-06-20".match(/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/).named_captures

Q27

"[ERROR] 2026-06-20 - Datebase timeout".match(/\[(?<level>\w+)\]\s+(?<date>[\d-]+)\s+-\s+(?<message>.+)/)


Q28

/(?<host>[a-z]+):(?<port>\d{3,4})/=~"localhost:3000"


Q29

"Alice Wonderland".gsub(/(?<first>\w+)\s+(?<second>\w+)/, '\k<second> \k<first>/')

Q30

"$100 and €200 and £300".match(/(?<=\$)\d+/)

Q31

"Great! Work harder. Amazing!".scan(/\w+(?=!)/)

Q32

PASSWORD = /
\A
(?=.*[A-Z])
(?=.*[a-z])
(?=.*\d)
.{8,}
\z
/x


Q33

"swordfish and blowfish".scan(/\w*(?<!sword)fish/)



Q34

text = "hello   \nworld  \nfoo"
text.gsub(/\s+(?=\n)/, '')