# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

t1 = Term.create(name: "Term 1 - 2016")

s1 = Subject.create(name: "Physics", currentMark: 96, weight: 1, term_id: t1.id)
Grade.create(courseItem: "a1", worth: 30, mark: 90, courseMark: 27, subject_id: s1.id)
Grade.create(courseItem: "a2", worth: 30, mark: 100, courseMark: 30, subject_id: s1.id)
Grade.create(courseItem: "a1", worth: 5, mark: 100, courseMark: 5, subject_id: s1.id)
Grade.create(courseItem: "a2", worth: 5, mark: 100, courseMark: 5, subject_id: s1.id)
Grade.create(courseItem: "a1", worth: 5, mark: 100, courseMark: 5, subject_id: s1.id)


s2 = Subject.create(name: "English", currentMark: 35.3, weight: 0.5, term_id: t1.id)
Grade.create(courseItem: "e1", worth: 10, mark: 22, courseMark: 2.2, subject_id: s2.id)
Grade.create(courseItem: "e2", worth: 10, mark: 33, courseMark: 3.3, subject_id: s2.id)
Grade.create(courseItem: "e3", worth: 20, mark: 43, courseMark: 8.6, subject_id: s2.id)

t2 = Term.create(name: "Term 2 - 2016")
s3 = Subject.create(name: "flying", currentMark: 84, weight: 0.5, term_id: t2.id)
Grade.create(courseItem: "e1", worth: 10, mark: 90, courseMark: 9, subject_id: s3.id)
Grade.create(courseItem: "e2", worth: 15, mark: 80, courseMark: 12, subject_id: s3.id)
