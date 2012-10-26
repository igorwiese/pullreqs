module RubyData

  def num_test_cases(pr_id)

    filter = lambda {|l| (not l.match(/^ *def +.*test.*/).nil?) or #Runit tests
        (not l.match(/^\s*should\s+.*\s+(do|{)/).nil?) or # Shoulda tests
        (not l.match(/^\s*it\s+.*\s+(do|{)/).nil?)} # Rspec tests

    count_lines(test_files(pr_id), filter)
  end

  def num_assertions(pr_id)
    count_lines(test_files(pr_id), lambda{|l| not l.match(/assert/).nil?})
  end

  def test_lines(pr_id)
    count_lines(test_files(pr_id), lambda{|l| l.match(/^\s*#/).nil?})
  end

  def test_files(pr_id)
    files_at_commit(pr_id, lambda{|f| f[:path].include?("test/") && f[:path].end_with?('.rb')}) +
    files_at_commit(pr_id, lambda{|f| f[:path].include?("spec/") && f[:path].end_with?('.rb')})
  end

  def src_files(pr_id)
    files_at_commit(pr_id,
                    lambda{ |f|
                      not f[:path].include?("test/") and
                      not f[:path].include?("spec/") and
                          f[:path].end_with?('.rb')
                    }
    )
  end

  def src_lines(pr_id)
    count_lines(src_files(pr_id), lambda{|l| l.match(/^\s*#/).nil?})
  end
end