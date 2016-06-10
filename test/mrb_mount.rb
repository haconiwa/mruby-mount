##
## Mount Test
##

assert("Mount#hello") do
  t = Mount.new "hello"
  assert_equal("hello", t.hello)
end

assert("Mount#bye") do
  t = Mount.new "hello"
  assert_equal("hello bye", t.bye)
end

assert("Mount.hi") do
  assert_equal("hi!!", Mount.hi)
end
