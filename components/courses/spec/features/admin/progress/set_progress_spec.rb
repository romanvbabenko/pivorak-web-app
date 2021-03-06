# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setting progress' do
  let!(:season)   { create(:season, title: 'Test Season') }
  let!(:user)     { create(:user) }
  let!(:venue)    { create(:venue) }
  let!(:mentor)   { ::Courses::Mentor.create(user: user, season: season) }
  let!(:lecture)  { create(:lecture, mentor: mentor, venue: venue, season: season) }
  let!(:student)  { create(:student, season: season, user: user, status: :attending) }
  let!(:progress) { ::Courses::Progress.create(student: student, lecture: lecture, mentor: mentor) }
  let!(:homework) do
    ::Courses::Homework.create(student: student, lecture: lecture, git_url: 'lorem',
                                                      showcase_url: 'ipsum', description: 'lorem')
  end

  before { visit "/admin/courses/seasons/test-season/lectures/#{lecture.slug}/progress" }

  context 'shows students list' do
    it { expect(page).to have_content(user.full_name) }
  end

  context 'has buttons to set student progress' do
    it 'has button for presence set' do
      expect(page).to have_link 'Absent!'
    end

    it 'has buttons for mark set' do
      ::Courses::Progress::ALLOWED_MARKS.compact.each do |mark|
        expect(page).to have_link mark.to_s
      end
    end
  end

  context 'progress set' do
    it 'changes presence mark after button pressing' do
      click_link 'Absent!'
      progress = ::Courses::Progress.last

      expect(progress.lecture_presence).to eq(-1)
    end

    it 'changes homework mark after button pressing' do
      click_link '-1'
      progress = ::Courses::Progress.last

      expect(progress.homework_mark).to eq(-1)
    end
  end
end
