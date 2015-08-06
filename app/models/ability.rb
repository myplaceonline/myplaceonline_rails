class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    identity = user.primary_identity
    
    can :manage, Password, :owner => identity
    can :manage, Movie, :owner => identity
    can :manage, IdentityFile, :owner => identity
    can :manage, Wisdom, :owner => identity
    can :manage, ToDo, :owner => identity
    can :manage, Contact, :owner => identity
    can :manage, Accomplishment, :owner => identity
    can :manage, Feed, :owner => identity
    can :manage, Location, :owner => identity
    can :manage, Activity, :owner => identity
    can :manage, Apartment, :owner => identity
    can :manage, Joke, :owner => identity
    can :manage, Company, :owner => identity
    can :manage, Promise, :owner => identity
    can :manage, Subscription, :owner => identity
    can :manage, CreditScore, :owner => identity
    can :manage, Website, :owner => identity
    can :manage, CreditCard, :owner => identity
    can :manage, BankAccount, :owner => identity
    can :manage, Idea, :owner => identity
    can :manage, List, :owner => identity
    can :manage, CalculationForm, :owner => identity
    can :manage, Calculation, :owner => identity
    can :manage, Vehicle, :owner => identity
    can :manage, Question, :owner => identity
    can :manage, Weight, :owner => identity
    can :manage, BloodPressure, :owner => identity
    can :manage, HeartRate, :owner => identity
    can :manage, Recipe, :owner => identity
    can :manage, SleepMeasurement, :owner => identity
    can :manage, Height, :owner => identity
    can :manage, Meal, :owner => identity
    can :manage, RecreationalVehicle, :owner => identity
    can :manage, Food, :owner => identity
    can :manage, Drink, :owner => identity
    can :manage, Vitamin, :owner => identity
    can :manage, AcneMeasurement, :owner => identity
    can :manage, Exercise, :owner => identity
    can :manage, SunExposure, :owner => identity
    can :manage, MedicineUsage, :owner => identity
    can :manage, Medicine, :owner => identity
    can :manage, IdentityFileFolder, :owner => identity
    can :manage, Pain, :owner => identity
    can :manage, Song, :owner => identity
    can :manage, BloodTest, :owner => identity
    can :manage, BloodConcentration, :owner => identity
    can :manage, BloodTestResult, :owner => identity
    can :manage, Checklist, :owner => identity
    can :manage, MedicalCondition, :owner => identity
    can :manage, LifeGoal, :owner => identity
    can :manage, Temperature, :owner => identity
    can :manage, Headache, :owner => identity
    can :manage, SkinTreatment, :owner => identity
    can :manage, PeriodicPayment, :owner => identity
    can :manage, Job, :owner => identity
    can :manage, Trip, :owner => identity
    can :manage, Passport, :owner => identity
    can :manage, Promotion, :owner => identity
    can :manage, RewardProgram, :owner => identity
    can :manage, Computer, :owner => identity
    can :manage, LifeInsurance, :owner => identity
    can :manage, DiaryEntry, :owner => identity
    can :manage, Restaurant, :owner => identity
    can :manage, CampLocation, :owner => identity
    can :manage, Gun, :owner => identity
    can :manage, DesiredProduct, :owner => identity
    can :manage, Book, :owner => identity
    can :manage, Warranty, :owner => identity
    can :manage, FavoriteProduct, :owner => identity
    can :manage, Therapist, :owner => identity
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
