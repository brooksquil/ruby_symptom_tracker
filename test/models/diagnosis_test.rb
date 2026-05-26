require "test_helper"

class DiagnosisTest < ActiveSupport::TestCase
  test "global diagnosis can exist without a user" do
    diagnosis = Diagnosis.create!(name: "Migraine")

    assert diagnosis.global?
    assert_nil diagnosis.user
    assert_equal "migraine", diagnosis.normalized_name
  end

  test "normalizes name and normalized_name" do
    diagnosis = Diagnosis.create!(name: "  Fibromyalgia  ")

    assert_equal "Fibromyalgia", diagnosis.name
    assert_equal "fibromyalgia", diagnosis.normalized_name
  end

  test "user custom diagnosis cannot duplicate a global diagnosis" do
    Diagnosis.create!(name: "POTS")

    diagnosis = users(:one).diagnoses.build(name: " pots ")

    assert_not diagnosis.valid?
    assert_includes diagnosis.errors[:name], "already exists in the common diagnosis list"
  end

  test "user cannot duplicate their own custom diagnosis case-insensitively" do
    users(:one).diagnoses.create!(name: "Custom diagnosis")

    diagnosis = users(:one).diagnoses.build(name: "custom diagnosis")

    assert_not diagnosis.valid?
    assert_includes diagnosis.errors[:normalized_name], "already exists"
  end

  test "different users can use the same custom diagnosis name" do
    users(:one).diagnoses.create!(name: "Rare condition")
    diagnosis = users(:two).diagnoses.build(name: "Rare condition")

    assert diagnosis.valid?
  end
end
