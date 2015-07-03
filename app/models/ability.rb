class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    identity = user.primary_identity
    
    can :manage, Password, :identity => identity
    can :manage, Movie, :identity => identity
    can :manage, IdentityFile, :identity => identity
    can :manage, Wisdom, :identity => identity
    can :manage, ToDo, :identity => identity
    can :manage, Contact, :identity => identity
    can :manage, Accomplishment, :identity => identity
    can :manage, Feed, :identity => identity
    can :manage, Location, :identity => identity
    can :manage, Activity, :identity => identity
    can :manage, Apartment, :identity => identity
    can :manage, Joke, :identity => identity
    can :manage, Company, :identity => identity
    can :manage, Promise, :identity => identity
    can :manage, Subscription, :identity => identity
    can :manage, CreditScore, :identity => identity
    can :manage, Website, :identity => identity
    can :manage, CreditCard, :identity => identity
    can :manage, BankAccount, :identity => identity
    can :manage, Idea, :identity => identity
    can :manage, List, :identity => identity
    can :manage, CalculationForm, :identity => identity
    can :manage, Calculation, :identity => identity
    can :manage, Vehicle, :identity => identity
    can :manage, Question, :identity => identity
    can :manage, Weight, :identity => identity
    can :manage, BloodPressure, :identity => identity
    can :manage, HeartRate, :identity => identity
    can :manage, Recipe, :identity => identity
    can :manage, SleepMeasurement, :identity => identity
    can :manage, Height, :identity => identity
    can :manage, Meal, :identity => identity
    can :manage, RecreationalVehicle, :identity => identity
    can :manage, Food, :identity => identity
    can :manage, Drink, :identity => identity
    can :manage, Vitamin, :identity => identity
    can :manage, AcneMeasurement, :identity => identity
    can :manage, Exercise, :identity => identity
    can :manage, SunExposure, :identity => identity
    can :manage, MedicineUsage, :identity => identity
    can :manage, Medicine, :identity => identity
    can :manage, IdentityFileFolder, :identity => identity
    can :manage, Pain, :identity => identity
    can :manage, Song, :identity => identity
    can :manage, BloodTest, :identity => identity
    can :manage, BloodConcentration, :identity => identity
    can :manage, BloodTestResult, :identity => identity
    can :manage, Checklist, :identity => identity
    can :manage, MedicalCondition, :identity => identity
    can :manage, LifeGoal, :identity => identity
    can :manage, Temperature, :identity => identity
    can :manage, Headache, :identity => identity
    can :manage, SkinTreatment, :identity => identity
    can :manage, PeriodicPayment, :identity => identity
    can :manage, Job, :identity => identity
    can :manage, Trip, :identity => identity
    can :manage, Passport, :identity => identity
    can :manage, Promotion, :identity => identity
    can :manage, RewardProgram, :identity => identity
    can :manage, Computer, :identity => identity
    can :manage, LifeInsurance, :identity => identity
    can :manage, DiaryEntry, :identity => identity
    can :manage, Restaurant, :identity => identity
    can :manage, CampLocation, :identity => identity
    
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
