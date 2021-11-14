# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  statement     :text
#  is_qcm        :boolean
#  decimal       :boolean          default(FALSE)
#  answer        :float
#  many_answers  :boolean          default(FALSE)
#  chapter_id    :integer
#  position      :integer
#  online        :boolean          default(FALSE)
#  explanation   :text
#  level         :integer          default(1)
#  nb_tries      :integer          default(0)
#  nb_firstguess :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Question < ActiveRecord::Base

  # BELONGS_TO, HAS_MANY

  belongs_to :chapter
  has_many :solvedquestions, dependent: :destroy
  has_many :users, through: :solvedquestions
  has_many :items, dependent: :destroy
  has_one :subject

  # VALIDATIONS

  validates :statement, presence: true, length: { maximum: 16000 } # Limited to 8000 in the form but end-of-lines count twice
  validates :explanation, length: { maximum: 16000 } # Limited to 8000 in the form but end-of-lines count twice
  validates :answer, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :level, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 4 }

  # Retourne la valeur de l'exercice
  def value
    return 3*level
  end
  
  # Mets à jour les nb_tries et nb_solved de chaque question (fait tous les mardis à 3 heures du matin (voir schedule.rb))
  # NB: Ils sont plus ou moins maintenus à jour en live, mais pas lorsqu'un utilisateur est supprimé, par exemple
  def self.update_stats
    nb_tries_by_question = Solvedquestion.group(:question_id).count
    nb_firstguess_by_question = Solvedquestion.where(:correct => true, :nb_guess => 1).group(:question_id).count
    Question.where(:online => true).each do |q|
      nb_tries = nb_tries_by_question[q.id]
      nb_firstguess = nb_firstguess_by_question[q.id]
      nb_tries = 0 if nb_tries.nil?
      nb_firstguess = 0 if nb_firstguess.nil?
      if q.nb_tries != nb_tries || q.nb_firstguess != nb_firstguess
        q.nb_tries = nb_tries
        q.nb_firstguess = nb_firstguess
        q.save
      end
    end
  end
end
