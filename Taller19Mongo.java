/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.mongodbmaven;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import static com.mongodb.client.model.Updates.set;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author Julian
 */
public class TallerMongo {
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("tallermongo");
        MongoCollection<Document> collectionProductos = database.getCollection("productos");
        MongoCollection<Document> collectionCategorias = database.getCollection("categorias");
        MongoCollection<Document> collectionComentarios = database.getCollection("comentarios");
        System.out.println("CONEXION EXITOSA");
        
        //INSERTAR 10 REGISTROS
        //Insertar Productos
        
        Document producto1 = new Document("productoID", "1")
            .append("Nombre", "Camiseta")
            .append("Descripcion", "Camiseta de algodón")
            .append("Precio", 5)
            .append("Categoria", new Document("categoriaID", "1")
                .append("NombreCategoria", "Parte superior"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "1").append("Texto", "Muy cómoda").append("Cliente", "Pablo"),
                new Document("comentarioID", "2").append("Texto", "Material suave").append("Cliente", "Laura")
            ));

        Document producto2 = new Document("productoID", "2")
            .append("Nombre", "Pantalón")
            .append("Descripcion", "Pantalón de mezclilla")
            .append("Precio", 35)
            .append("Categoria", new Document("categoriaID", "2")
                .append("NombreCategoria", "Parte inferior"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "3").append("Texto", "Muy resistente").append("Cliente", "María"),
                new Document("comentarioID", "4").append("Texto", "Buen ajuste").append("Cliente", "Carlos")
            ));

        Document producto3 = new Document("productoID", "3")
            .append("Nombre", "Zapatos")
            .append("Descripcion", "Zapatos deportivos")
            .append("Precio", 50)
            .append("Categoria", new Document("categoriaID", "3")
                .append("NombreCategoria", "Calzado"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "5").append("Texto", "Muy cómodos para correr").append("Cliente", "Luis"),
                new Document("comentarioID", "6").append("Texto", "Buena relación calidad-precio").append("Cliente", "Ana")
            ));

        Document producto4 = new Document("productoID", "4")
            .append("Nombre", "Gorra")
            .append("Descripcion", "Gorra ajustable")
            .append("Precio", 3)
            .append("Categoria", new Document("categoriaID", "4")
                .append("NombreCategoria", "Accesorios"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "7").append("Texto", "Excelente diseño").append("Cliente", "Juan"),
                new Document("comentarioID", "8").append("Texto", "Muy ligera").append("Cliente", "Claudia")
            ));

        Document producto5 = new Document("productoID", "5")
            .append("Nombre", "Bufanda")
            .append("Descripcion", "Bufanda de lana")
            .append("Precio", 2)
            .append("Categoria", new Document("categoriaID", "4")
                .append("NombreCategoria", "Accesorios"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "9").append("Texto", "Ideal para invierno").append("Cliente", "Sofía"),
                new Document("comentarioID", "10").append("Texto", "Calienta muy bien").append("Cliente", "Pedro")
            ));

        Document producto6 = new Document("productoID", "6")
            .append("Nombre", "Sombrero")
            .append("Descripcion", "Sombrero de playa")
            .append("Precio", 30)
            .append("Categoria", new Document("categoriaID", "4")
                .append("NombreCategoria", "Accesorios"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "11").append("Texto", "Perfecto para el verano").append("Cliente", "Luis"),
                new Document("comentarioID", "12").append("Texto", "Buen material").append("Cliente", "Fernanda")
            ));

        Document producto7 = new Document("productoID", "7")
            .append("Nombre", "Chaqueta")
            .append("Descripcion", "Chaqueta impermeable")
            .append("Precio", 60)
            .append("Categoria", new Document("categoriaID", "1")
                .append("NombreCategoria", "Parte superior"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "13").append("Texto", "Resistente al agua").append("Cliente", "Mario"),
                new Document("comentarioID", "14").append("Texto", "Perfecta para días lluviosos").append("Cliente", "Valeria")
            ));

        Document producto8 = new Document("productoID", "8")
            .append("Nombre", "Sudadera")
            .append("Descripcion", "Sudadera con capucha")
            .append("Precio", 60)
            .append("Categoria", new Document("categoriaID", "1")
                .append("NombreCategoria", "Ropa"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "15").append("Texto", "Muy abrigada").append("Cliente", "Alejandra"),
                new Document("comentarioID", "16").append("Texto", "Cierre de buena calidad").append("Cliente", "Oscar")
            ));

        Document producto9 = new Document("productoID", "9")
            .append("Nombre", "Mochila")
            .append("Descripcion", "Mochila escolar")
            .append("Precio", 45)
            .append("Categoria", new Document("categoriaID", "4")
                .append("NombreCategoria", "Accesorios"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "17").append("Texto", "Gran capacidad").append("Cliente", "Diego"),
                new Document("comentarioID", "18").append("Texto", "Cómoda de llevar").append("Cliente", "Lucía")
            ));

        Document producto10 = new Document("productoID", "10")
            .append("Nombre", "Cinturón")
            .append("Descripcion", "Cinturón de cuero")
            .append("Precio", 20)
            .append("Categoria", new Document("categoriaID", "4")
                .append("NombreCategoria", "Accesorios"))
            .append("Comentarios", Arrays.asList(
                new Document("comentarioID", "19").append("Texto", "Diseño elegante").append("Cliente", "Javier"),
                new Document("comentarioID", "20").append("Texto", "Material duradero").append("Cliente", "Andrea")
            ));

        collectionProductos.insertMany(Arrays.asList(
            producto1, producto2, producto3, producto4, producto5, 
            producto6, producto7, producto8, producto9, producto10
        ));
        
        
        //Insertar Categorias
        
        Document categoria1 = new Document("categoriaID","1").append("NombreCategoria", "Parte superior");
        Document categoria2 = new Document("categoriaID", "2").append("NombreCategoria", "Parte inferior");
        Document categoria3 = new Document("categoriaID", "3").append("NombreCategoria", "Calzado");
        Document categoria4 = new Document("categoriaID", "4").append("NombreCategoria", "Accesorios");
        collectionCategorias.insertMany(Arrays.asList(categoria1,categoria2,categoria3,categoria4));
        
        
        //Insertar Comentarios
        
        Document comentario1 = new Document("comentarioID","1").append("Texto", "Muy comodo").append("Cliente", "Pablo");
        Document comentario2 = new Document("comentarioID", "2").append("Texto", "Excelente calidad").append("Cliente", "María");
        Document comentario3 = new Document("comentarioID", "3").append("Texto", "Buena relación calidad-precio").append("Cliente", "Luis");
        Document comentario4 = new Document("comentarioID", "4").append("Texto", "El diseño es muy bonito").append("Cliente", "Ana");
        collectionComentarios.insertMany(Arrays.asList(comentario1,comentario2,comentario3,comentario4));
        
        
        //ACTUALIZAR 5 REGISTROS CON RESPECTO A LA CATEGORIA
        
        collectionProductos.updateOne(eq("Categoria","1"), set("Descripcion","Camiseta de poco algodon"));
        collectionProductos.updateOne(eq("Categoria","2"), set("Nombre","Pantaloneta"));
        collectionProductos.updateOne(eq("Categoria","3"), set("Nombre","Zapatillas"));
        collectionProductos.updateOne(eq("Categoria","4"), set("Precio",15));
        collectionProductos.updateOne(eq("Categoria","3"), set("Precio",50));
        
        
        //ELIMINAR 2 REGISTROS
        
        collectionProductos.deleteOne(eq("productoID","3"));
        collectionProductos.deleteOne(eq("productoID","4"));
        

        //CONSULTAR PRODUCTOS CON PRECIO MAYOR A 10
        
        MongoCursor<Document> cursor = collectionProductos.find(gt("Precio", 10)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
        
        
        //CONSULTAR PRODUCTOS CON PRECIO MAYOR A 50 Y LA CATEGORIA SEA ROPA
        MongoCursor<Document> cursor2 = collectionProductos.find(and(gt("Precio", 50),eq("Categoria.NombreCategoria","Ropa"))).iterator();
        while (cursor2.hasNext()) {
            System.out.println(cursor2.next().toJson());
        }
        
    }
}
