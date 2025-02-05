import 'package:flutter/material.dart';
import 'apiget.dart';
import 'apiresult.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telefon Fiyat Tahmini',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PriceCheckerScreen(),
    );
  }
}

class PriceCheckerScreen extends StatefulWidget {
  @override
  _PriceCheckerScreenState createState() => _PriceCheckerScreenState();
}

class _PriceCheckerScreenState extends State<PriceCheckerScreen> {
  // Kullanıcı seçimleri (default olarak boş bırakıldı)
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedBrand;
  String? selectedModel;
  String? selectedCondition;

  // Kategori - Alt Kategori Listeleri
  final Map<String, List<String>> categories = {
    "Elektronik": ["Cep Telefonu", "Bilgisayar", "Tablet"]
  };

  final Map<String, List<String>> subCategories = {
    "Cep Telefonu": ["iPhone", "Samsung", "Xiaomi", "OnePlus"]
  };

  final Map<String, List<String>> brands = {
    "iPhone": ["iPhone 11", "iPhone 12", "iPhone 13", "iPhone 14"],
    "Samsung": ["Galaxy S21", "Galaxy S22", "Galaxy S23"],
    "Xiaomi": ["Mi 11", "Mi 12", "Redmi Note 10"],
  };

  final List<String> conditions = ["Yeni", "İkinci El"];

  List<ApiResult> results = [];
  bool isLoading = false;

  void fetchPrices() async {
    setState(() => isLoading = true);
    try {
      // Seçilen bilgileri birleştiriyoruz
      String query =
          "$selectedSubCategory $selectedBrand $selectedModel $selectedCondition";

      List<dynamic> data = await ApiGet.getPhonePrices(query);
      setState(() {
        results = data.map((json) => ApiResult.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Telefon Fiyat Tahmini")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Kategori Seçimi
            DropdownButton<String>(
              value: selectedCategory,
              hint: Text("Kategori Seçiniz"),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                  selectedSubCategory = null;
                  selectedBrand = null;
                  selectedModel = null;
                  selectedCondition = null;
                });
              },
              items: categories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),

            // 2. Alt Kategori Seçimi (Kategori seçilmeden görünmez)
            if (selectedCategory != null)
              DropdownButton<String>(
                value: selectedSubCategory,
                hint: Text("Alt Kategori Seçiniz"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubCategory = newValue;
                    selectedBrand = null;
                    selectedModel = null;
                    selectedCondition = null;
                  });
                },
                items: categories[selectedCategory]!.map((String subCat) {
                  return DropdownMenuItem<String>(
                    value: subCat,
                    child: Text(subCat),
                  );
                }).toList(),
              ),

            // 3. Marka Seçimi (Alt kategori seçilmeden görünmez)
            if (selectedSubCategory != null)
              DropdownButton<String>(
                value: selectedBrand,
                hint: Text("Marka Seçiniz"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBrand = newValue;
                    selectedModel = null;
                    selectedCondition = null;
                  });
                },
                items: subCategories[selectedSubCategory]!.map((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
              ),

            // 4. Model Seçimi (Marka seçilmeden görünmez)
            if (selectedBrand != null)
              DropdownButton<String>(
                value: selectedModel,
                hint: Text("Model Seçiniz"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedModel = newValue;
                    selectedCondition = null;
                  });
                },
                items: brands[selectedBrand]!.map((String model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
              ),

            // 5. Durum Seçimi (Model seçilmeden görünmez)
            if (selectedModel != null)
              DropdownButton<String>(
                value: selectedCondition,
                hint: Text("Durum Seçiniz"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCondition = newValue;
                  });
                },
                items: conditions.map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
              ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  isLoading || selectedCondition == null ? null : fetchPrices,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("Fiyatları Getir"),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(results[index].title),
                    subtitle: Text(results[index].price),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () => print("Ürün linki: ${results[index].link}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
