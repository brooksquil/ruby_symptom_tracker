require "test_helper"

class SymptomTest < ActiveSupport::TestCase
  test "global symptom can exist without a user" do
    symptom = Symptom.create!(name: "Fatigue")

    assert symptom.global?
    assert_nil symptom.user
    assert_equal "fatigue", symptom.normalized_name
  end

  test "normalizes name and normalized_name" do
    symptom = Symptom.create!(name: "  Joint Pain  ")

    assert_equal "Joint Pain", symptom.name
    assert_equal "joint pain", symptom.normalized_name
  end

  test "user custom symptom cannot duplicate a global symptom" do
    Symptom.create!(name: "Brain fog")

    symptom = users(:one).symptoms.build(name: " brain FOG ")

    assert_not symptom.valid?
    assert_includes symptom.errors[:name], "already exists in the common symptom list"
  end

  test "user cannot duplicate their own custom symptom case-insensitively" do
    users(:one).symptoms.create!(name: "Vertigo")

    symptom = users(:one).symptoms.build(name: "vertigo")

    assert_not symptom.valid?
    assert_includes symptom.errors[:normalized_name], "already exists"
  end

  test "different users can use the same custom symptom name" do
    users(:one).symptoms.create!(name: "Custom flare symptom")
    symptom = users(:two).symptoms.build(name: "Custom flare symptom")

    assert symptom.valid?
  end
end
