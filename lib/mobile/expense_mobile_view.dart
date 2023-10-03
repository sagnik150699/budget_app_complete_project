import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components.dart';
import '../view_model.dart';

bool isLoading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    final double categoryWidth = MediaQuery.of(context).size.width;

    if (isLoading == true) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      isLoading = false;
    }

    return SafeArea(
      child: Scaffold(
        drawer: DrawerExpense(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 30.0),
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Poppins(
            text: "Dashboard",
            size: 20.0,
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
            SizedBox(height: 40.0),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: categoryWidth / 1.5,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: TotalCalculation(14.0),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Add expense
                AddExpense(),
                SizedBox(width: 10.0),
                //Add income
                AddIncome(),
              ],
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //expense list
                  Column(
                    children: [
                      OpenSans(
                        text: "Expenses",
                        size: 15.0,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.all(7.0),
                          height: 210,
                          width: 180.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                          child: ListView.builder(
                            itemCount: viewModelProvider.expenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return IncomeExpenseRowMobile(
                                text: viewModelProvider.expenses[index].name,
                                amount:
                                    viewModelProvider.expenses[index].amount,
                              );
                            },
                          )),
                    ],
                  ),

                  //income list
                  Column(
                    children: [
                      OpenSans(
                        text: "Incomes",
                        size: 15.0,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.all(7.0),
                          height: 210,
                          width: 180.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                          child: ListView.builder(
                            itemCount: viewModelProvider.incomes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return IncomeExpenseRowMobile(
                                text: viewModelProvider.incomes[index].name,
                                amount: viewModelProvider.incomes[index].amount,
                              );
                            },
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
