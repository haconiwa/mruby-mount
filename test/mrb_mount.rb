##
## Mount Test
##

assert("Mount#hello") do
  t = Mount.new
  assert_equal(Mount, t.class)
end
