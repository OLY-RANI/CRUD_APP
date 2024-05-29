import 'dart:async';
import 'dart:convert';

import 'package:crud_app/add_product_screen.dart';
import 'package:crud_app/product.dart';
import 'package:crud_app/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _getProductListInProgress = false;
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductItem(productList[index]);
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async{
    _getProductListInProgress = true;
    setState(() {});
    productList.clear();

    const String productListUrl = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productListUrl);

    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      //Data Decode
      final decodedData = jsonDecode(response.body);
      //get the list
      final jsonProductList = decodedData['data'];
      //loop over the list

      for(Map<String, dynamic> p in jsonProductList)
        {
         /* ProductModel productModel = ProductModel.fromJson(json);*/

          Product product = Product(
              id: p['_id'] ?? '',
              productName: p['ProductName']?? '',
              productCode: p['ProductCode']?? '',
              image: p['Img']?? '',
              unitPrice: p['UnitPrice']?? '',
              quantity: p['Qty']?? '',
              totalPrice: p['TotalPrice']?? '',
          );

          productList.add(product);

        }

    }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Get Product List Failed! Try Again.'),
          ),
        );

      }
    _getProductListInProgress = false;
    setState(() {});
  }

  Widget _buildProductItem(Product product) {
    return ListTile(
      /*  leading: Image.network('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3N//AABEIAJQAxAMBIgACEQEDEQH/xAAcAAEAAQUBAQAAAAAAAAAAAAAAAQIDBAUHCAb/xAA4EAABAwMCBAMGBAUFAQAAAAABAAIDBAURITEGEkFRE2FxByIyQoGRFBVSoSMzsdHwJGJysuEW/8QAFgEBAQEAAAAAAAAAAAAAAAAAAAEC/8QAGBEBAQEBAQAAAAAAAAAAAAAAAAECESH/2gAMAwEAAhEDEQA/AOyqQoUhESiIgIURBCIiAiIgIpRBCKUQQilEEIpRBCKVOEFKlThQgIiICIiAiIgIiICIiAihCglFCIJRQqkEIpKhAREQEREBERAREQEREBERAQIgQT0UKUQQhUqCghQpRBRLIyKJ8kr2sjY0uc5xwGgbkrmXEPtGnq6mSHhariDIdHl8bWvfnTI59A3bca9+h+84oEpsNY2JniB8TmvBOzSNSvOMgkMfuglzQWgsw1xGevf6oOqcPe0owSspuI3F5kbzCWGMDwx/uxga4OANV9xS8UWGrkZFT3WldI8AtZz4JyM9fVebrXdaikuDfzKJ9TRyPDJIpT4eX7A6dhn7rd1NwsNHXzinhqZKmnfzMilkaIiTsOYDJAz+yD0cSAM5075WNR19HXh5oaqCoEbuR/hSB3K7scLhdy4z4irbE2g8eOaIMwTF/DdL2BI+UfTPXKweHZ6q226uqJrzLS1Mp8MwwNcwBnLqQdjjOBkoPRSLzbaOMrjYbnDJR3CplDnjnhneXtkB/UPl9RqN/I+hrTcoLrboK6lOY5mc2M5weo+h0QZiKMqcoCIiAiIgIiICIiAgRAglERAVJKlUOQTzJzBWHPwrXjYQYXGdYaThS6TsOHMp3YXnMTNqfglMMgcSNdNei79xwfG4PurB1p3aLzYZv9QW5Qb6CndWsEFbHFzOJAJIwdN8rSVdHJSTP/hObEXaHm5s9slZIr/wrWlzwG/pdr+yroeIKqnqnwwwQz0lThkkNS3DHjBHxH4fiJz6KjFpaianOYXkDsdj9Fn19xndahKxrA4Shh01GQSCPsthLbbNcHtZSPmtFe/lIpq148F4LgMsf6ZO5BxgLUzRCFtxtlZIyOeJzObDuYBwcAcY30KK09JHUVFdGymYXzF4Ldt89SdAPMruHsw4igtNofaLhIJJGTGSBtOefljcM4PmCDoM7hcot8wsUZrLdUNlmbKA8nOC3OMFvZb+4XKhrr81oklikeBI6oMrSzHL021yiPQtNUx1MDJ4Hh8bxkOxj9jqD5FXg5cA4I4wvFnroIZGuZaZy58fiNPJKObGGH9WvQ+oXe8qC6CpyrQKrBQVKVSpQSiIgIiICBECCVClQgKhyrKocgsyNWM9uuyzDssStqaejp31FVKyKFgy57zgINbfYfHslwi707/+pXnmksJNTJU3KX8NEHZYzl5nP+nQLonFPtAZXufRW+WSnpjoXNx4kv3xgeS+I8KavkDKWpFRI44Ebx4b3HsASQfoSkF+itdFcHCNlRSmbUgPZ4YAHrrn6n0WJcY3QRc1RG2SDGjmjOmcA+hWlr6qSnlfDIx0csbuVzHAgtI7q9Fe664GCmqKwFrMRsM2zWnTOd/IjXTRUY8FPJW3Omprc8h7ncsQLtBnXY9N9Fl19mqqCoq5KmmjaIsMkdEcNHMPdcB1afLr1SKFtPUzND4hV0snyOyx2Ox7f0+iv1VXcax8twE0lTE5jopmuJcfDOpBHTGuvfJUGught0zC78xlpLg1zy4yM/hSDUjBGoOgGuiv1tmlppHRXKCOKfRzJIzlsjTs4Y0IOq1/htcXRyAHGx8lmULGw05jbrl2c4VH01mp6ZlNzxxxtmaPdAzsNCdfsu82asFdaaOpDy7xIwS4/N0z+y4fQ3swcPSW4Uoe0tkHM6TTLsHOMdC0Y1XcrZG2K10UbAAGU8YGP+IQZzSqwVYBV1hUF0KoKkKpBKIiAiIgIEQIJVJKqKoKASqHOUOdhWXvQWblXwW6imrKl/LDCwudjc+Q81ybiLiio4jhM3iQUlDG5wiZO3Vx7/FqfQY7Z3X1/tQe/wD+Lr3R59zlcQO2dVxRkzam72qGsIkphExvI74cE/3QV19iZM1skrYITI4CKSF+jsjOS06AeeVkU1FbrtQm1zO/Lr3BoySQ5iqSPlOdWu6/3XSJLDbb9SGtn/MZZGxhhZSyBwjYBj+U7RwxuNT5Lm/GXDlZb3U00NTHWW2bIpqpmdR+gk6gjsdtsrM37ykvWkra2ou4Zb7mGOuNOfCiqnH3n4+R56+RWjcwxPcyRpa5pIc0jUEbq5O10crmynmcDvuSrtQ+SvDJyC6YAMkd1djQE+eBv1wtKuUkDZaSeobUsjni5RHDy6y5OCAe631htlTLT1dMWMcalmzs5HJl2nnoQrHDtH+Hq4/GGS9waR2J2/zzW9uNRNa3T1MDHObGHteRpq9pA18s5+iqPjJWPhqzE85fGAxx8xus6n+AFYtv8B/jCeIve5hERYNRJ03O2/nssqH3RynO/VBuYM/hCB1OPovRdPyfhIDDnwjEzkyMaYGP2XnegY+f8PBGMmWZsePUgL0axucBrcAbAaAIDRlX2NKlkWFdAwoIaFUEwpQQiIgIiICKVCAqXKpQUFh+yxZcjZZrmgq05iDTXOjiuVBU0NV/KqInRu8gRjP03Xna5UE9JTup5o2xXCzymKcA4MkZOWvHpqPQhemZYB03XOvaTwpVVb475ZI2m507CyWItBFTF1aQdzv6g+iDR8E8TmMxTsedfjHYr7e52ujusNR4DYxRXVjvEh2EVUBzMkHbmAcD3OFwyNslAX1tra91KDyywPPvwH9Lxv6O23X2nDXG1IIHQzziLTOJdmOGxHp3wsXLGc2ac5raGZ9dKGAuAYZGnqW/36eq3VkoI4vHhHvtnp3EE9SBzsP3aPuVsI4oHupZaUSOp3SujY6QYc9m39Tn6LM4TsVZc6iOKmYWsji5Hzn4Y8tIHqcHZbjd8V8G2iW6XaOOBo5YwXyOdswYwP3XVafhy309vdSFgk5yXSvc3V7j3VVltVFZKJtLbmcrd3vOrnu7k9f8C2UbXPIyqz1z66eyihqi6S11DqSUjQD4ft0+i+SqfZvxVSzeHHbxUtzpJDMwg/cg/dd7jiwFkMYEWPheAuA/yhrKy8NY+u3YwEObD/6ugsa1qpaFcCiquilQEQSoREBERAREQSoUoUEIiIIIVJaq0KCw5gWNPCCNlnEKksBQcz404BdcpRcbJIKO5t1LvllHZw2XNamw3KOfkuXCsjagO1kpHODJN/lbo3JwdMei9KmNp3CtGCPOeUfZByGwcOV1wmhdcaM0FDTj+BTt3GddzqdepX3VDQQ0VMymoYRFEzZo6+ZO5Pn1X0hhZ+gfZQIWA5ARGsgpXHVwWdFDgbLIDAFWAhxQ1miqwqgpARUBVqFKCQihSgIiICIiAiIglCiFBCIiAhREEKOiqUIKVCqRBQgCrIQBBThThSmEAIpARAUKUQQpCKQgIiICIiAiIglCiIIREQEREBSoRAwihEBERBOFCIgIiICIiAiIgKURAREQEREH/9k=',
              height: 60,),*/
      title: Text('${product.productName}'),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text('Product Price: ${product.unitPrice}'),
          Text('Product Amount: ${product.quantity}'),
          Text('Total Price: ${product.totalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => UpdateProductScreen(
                          product: product,
                        )),
              );
              if(result == true){
                _getProductList();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_sharp),
            onPressed: () {
              _showDeleteConfirmationDialoge(product.id!);
            },
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialoge(String productId){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure sure that you want to delete this product?'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
              TextButton(onPressed: (){
                _deleteProductList(productId);
                Navigator.pop(context);
              }, child: Text('Yes, Delete')),
            ],
          );
        });
  }
  Future<void> _deleteProductList(String productId) async{
    _getProductListInProgress = true;
    setState(() {});


    String deleteProductUrl = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri uri = Uri.parse(deleteProductUrl);

    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      _getProductList();

    }
    else
    {
      _getProductListInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete Product List Failed! Try Again.'),
        ),
      );

    }

  }

}


//https://images.pexels.com/photos/292999/pexels-photo-292999
