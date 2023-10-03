import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components.dart';
import '../view_model.dart';

bool isLoading = true;

class ExpenseViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    if (isLoading == true) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      isLoading = false;
    }

    return Scaffold(
      drawer: DrawerExpense(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 35.0),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Poppins(
          text: "Dashboard",
          size: 30.0,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await viewModelProvider.reset();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50.0,
          ),

          //image+addIncome+total calculations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/login_image.png",
                width: deviceHeight / 1.6,
              ),
              //add income+expense
              SizedBox(
                height: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Add expense
                    AddExpense(),
                    SizedBox(height: 30.0),
                    //Add income
                    AddIncome(),
                  ],
                ),
              ),
              SizedBox(width: 30.0),
              //Total calculation
              Container(
                  height: 300.0,
                  width: 280.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: TotalCalculation(17.0)),
            ],
          ),
          SizedBox(height: 40.0),
          Divider(
            indent: deviceWidth / 4,
            endIndent: deviceWidth / 4,
            thickness: 3.0,
          ),
          SizedBox(height: 50.0),

          //Expenses+Income
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Expenses
              Container(
                height: 320.0,
                width: 260.0,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: [
                    //Expenses heading
                    Center(
                      child: Poppins(
                        text: "Expenses",
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      indent: 30.0,
                      endIndent: 30.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            border:
                                Border.all(width: 1.0, color: Colors.white)),
                        child: ListView.builder(
                          itemCount: viewModelProvider.expenses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return IncomeExpenseRow(
                              text: viewModelProvider.expenses[index].name,
                              amount: viewModelProvider.expenses[index].amount,
                            );
                          },
                        ))
                  ],
                ),
              ),
              //Income
              Container(
                height: 320.0,
                width: 260.0,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: [
                    //Incomes heading
                    Center(
                      child: Poppins(
                        text: "Incomes",
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      indent: 30.0,
                      endIndent: 30.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            border:
                                Border.all(width: 1.0, color: Colors.white)),
                        child: ListView.builder(
                          itemCount: viewModelProvider.incomes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return IncomeExpenseRow(
                              text: viewModelProvider.incomes[index].name,
                              amount: viewModelProvider.incomes[index].amount,
                            );
                          },
                        ))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
