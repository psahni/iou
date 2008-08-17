require 'test_helper'

class BillTest < ActiveSupport::TestCase
  def test_from_different_from_to
    bill = bills(:julie_owes_sunny)
    bill.from_user_id = 1
    bill.to_user_id   = 1
    assert !bill.valid?, "From and to cannot not be the same"
  end

  def test_action
    bill = bills(:julie_owes_sunny)
    assert_equal "Julie owes Sunny", bill.action
  end

  def test_title_for_bill_with_a_description
    bill = bills(:julie_owes_sunny)
    assert_equal bill.description, bill.title
  end

  def test_title_for_bill_without_a_description
    bill = bills(:sunny_is_reimbursed_by_julie)
    assert_equal bill.action, bill.title
  end

  def test_verbs
    paye = Bill.new(:payment => true)
    owe  = Bill.new(:payment => false)
    assert_equal "pay", paye.verb
    assert_equal "owe", owe.verb
    assert_equal "payed", paye.past_verb
    assert_equal "owes",  owe.past_verb
  end

  def test_debt_and_loans_for_user
    sunny = users(:sunny)
    julie = users(:julie)

    sunny_debts = Bill.debts_for_user(sunny)
    julie_debts = Bill.debts_for_user(julie)

    assert_equal -0.5, sunny_debts[julie]
    assert_equal  0.5, julie_debts[sunny]
  end
end
