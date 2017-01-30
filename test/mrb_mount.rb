##
## Mount Test
##

assert("Mount class") do
  t = Mount.new
  assert_equal(Mount, t.class)
end
