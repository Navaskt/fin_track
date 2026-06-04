import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  groceries,
  transport,
  taxi,
  bills,
  utilities,
  insurance,
  creditCard,
  credit,
  shopping,
  health,
  entertainment,
  rent,
  coffee,
  fuel,
  education,
  other;

  String getTranslation(BuildContext context) {
    switch (this) {
      case ExpenseCategory.food:
        return context.loc.food;
      case ExpenseCategory.groceries:
        return context.loc.groceries;
      case ExpenseCategory.transport:
        return context.loc.transport;
      case ExpenseCategory.taxi:
        return context.loc.taxi;
      case ExpenseCategory.bills:
        return context.loc.bills;
      case ExpenseCategory.utilities:
        return context.loc.utilities;
      case ExpenseCategory.insurance:
        return context.loc.insurance;
      case ExpenseCategory.creditCard:
        return context.loc.creditCard;
      case ExpenseCategory.credit:
        return context.loc.credit;
      case ExpenseCategory.shopping:
        return context.loc.shopping;
      case ExpenseCategory.health:
        return context.loc.health;
      case ExpenseCategory.entertainment:
        return context.loc.entertainment;
      case ExpenseCategory.rent:
        return context.loc.rent;
      case ExpenseCategory.coffee:
        return context.loc.coffee;
      case ExpenseCategory.fuel:
        return context.loc.fuel;
      case ExpenseCategory.education:
        return context.loc.education;
      case ExpenseCategory.other:
        return context.loc.other;
    }
  }
}

enum IncomeCategory {
  salary,
  bonus,
  interest,
  refund,
  gift,
  investment,
  incentive,
  other;

  String getTranslation(BuildContext context) {
    switch (this) {
      case IncomeCategory.salary:
        return context.loc.salary;
      case IncomeCategory.bonus:
        return context.loc.bonus;
      case IncomeCategory.interest:
        return context.loc.interest;
      case IncomeCategory.refund:
        return context.loc.refund;
      case IncomeCategory.gift:
        return context.loc.gift;
      case IncomeCategory.investment:
        return context.loc.investment;
      case IncomeCategory.incentive:
        return context.loc.incentive;
      case IncomeCategory.other:
        return context.loc.other;
    }
  }
}
