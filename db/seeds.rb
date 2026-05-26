# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

global_symptoms = [
  "Abdominal pain",
  "Anxiety",
  "Back pain",
  "Balance problems",
  "Bloating",
  "Blurry vision",
  "Brain fog",
  "Burning sensation",
  "Chest pain",
  "Chills",
  "Cold intolerance",
  "Cold sweats",
  "Concentration problems",
  "Constipation",
  "Cough",
  "Daytime sleepiness",
  "Depression",
  "Diarrhea",
  "Difficulty making decisions",
  "Difficulty swallowing",
  "Dizziness",
  "Dry eyes",
  "Dry mouth",
  "Dry skin",
  "Excessive thirst",
  "Fatigue",
  "Fever",
  "Frequent urination",
  "Gas",
  "Generalized pain",
  "Hair loss",
  "Headache",
  "Hearing changes",
  "Heart palpitations",
  "Heartburn",
  "Heat intolerance",
  "Heavy menstrual bleeding",
  "Hot flashes",
  "Increased appetite",
  "Insomnia",
  "Irregular periods",
  "Irritability",
  "Itching",
  "Joint pain",
  "Light sensitivity",
  "Loss of appetite",
  "Memory problems",
  "Migraine",
  "Mood swings",
  "Muscle cramps",
  "Muscle pain",
  "Muscle spasms",
  "Nausea",
  "Neck pain",
  "Night sweats",
  "Non-restorative sleep",
  "Numbness",
  "Painful urination",
  "Pelvic pain",
  "Racing heart",
  "Rash",
  "Redness",
  "Restless sleep",
  "Runny nose",
  "Sadness",
  "Shortness of breath",
  "Sleep problems",
  "Sore throat",
  "Sound sensitivity",
  "Speech problems",
  "Stiffness",
  "Stress",
  "Swelling",
  "Temperature sensitivity",
  "Tingling",
  "Tinnitus",
  "Tremors",
  "Urinary urgency",
  "Vertigo",
  "Vision changes",
  "Vomiting",
  "Weakness",
  "Weight gain",
  "Weight loss",
  "Wheezing"
]

global_symptoms.uniq.each do |name|
  normalized_name = name.strip.downcase
  symptom = Symptom.find_or_initialize_by(user_id: nil, normalized_name: normalized_name)
  symptom.name = name
  symptom.save!
end

User.find_or_create_by!(email_address: "test@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end