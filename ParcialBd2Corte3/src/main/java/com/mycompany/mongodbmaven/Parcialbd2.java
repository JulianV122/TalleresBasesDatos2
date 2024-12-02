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
import com.mongodb.client.model.InsertOneModel;
import static com.mongodb.client.model.Updates.set;
import java.sql.Date;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author Julian
 */
public class Parcialbd2 {
    public static void main(String[] args) {
        //Conexión Mongo
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("parcial");
        MongoCollection<Document> collectionPedidos = database.getCollection("pedidos");
        MongoCollection<Document> collectionProductos = database.getCollection("productos");
        MongoCollection<Document> collectionDetallesPedidos = database.getCollection("detalles_pedidos");
        System.out.println("CONEXION EXITOSA");
        
        CrearProducto(collectionProductos,"1","Agua","Agua normal",23.0,25);
        
        
        //Neo4J
        Neo4J.connect();
        PersonaService personaService = new PersonaService();
        Neo4J.close();
        
        
    }
    //PRIMERA PREGUNTA
    //CRUD PRODUCTOS
    public static void CrearProducto(MongoCollection<Document> collection,String id, String nombre, String descripcion, Double precio, int stock ){
        Document producto= new Document("_id", id)
            .append("Nombre", nombre)
            .append("Descripcion", descripcion)
            .append("Precio", precio)
            .append("Stock", stock);
        collection.insertOne(producto);
    }
    
    public static void EditarProducto(MongoCollection<Document> collection,String id, String nombre, String descripcion, Double precio, int stock){
        collection.updateOne(eq("_id",id), set("Nombre",nombre));
        collection.updateOne(eq("_id",id), set("Descripcion",descripcion));
        collection.updateOne(eq("_id",id), set("Precio",precio));
        collection.updateOne(eq("_id",id), set("Stock",stock));
    }
    
    public static void EliminarProdcuto(MongoCollection<Document> collection,String id){
        collection.deleteOne(eq("_id",id));
    }
    
    public static void MostrarProducto(MongoCollection<Document> collection,String id){
         MongoCursor<Document> cursor = collection.find(eq("_id", id)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    //CRUD PEDIDOS
    public static void CrearPedido(MongoCollection<Document> collection,String id, String pedido_id, Date producto_id, String cantidad, Double precio_unitario ){
        Document producto= new Document("_id", id)
            .append("pedido_id", pedido_id)
            .append("producto_id", producto_id)
            .append("cantidad", cantidad)
            .append("precio_unitario", precio_unitario);
        collection.insertOne(producto);
    }
    
    public static void EditarPedido(MongoCollection<Document> collection,String id, String pedido_id, Date producto_id, String cantidad, Double precio_unitario){
        collection.updateOne(eq("_id",id), set("pedido_id", pedido_id));
        collection.updateOne(eq("_id",id), set("producto_id", producto_id));
        collection.updateOne(eq("_id",id), set("cantidad", cantidad));
        collection.updateOne(eq("_id",id), set("precio_unitario", precio_unitario));
    }
    
    public static void EliminarPedido(MongoCollection<Document> collection,String id){
        collection.deleteOne(eq("_id",id));
    }
    
    public static void MostrarPedido(MongoCollection<Document> collection,String id){
         MongoCursor<Document> cursor = collection.find(eq("_id", id)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    
    //CRUD PEDIDOS
    public static void CrearDetallePedido(MongoCollection<Document> collection,String id, String pedido_id, String producto_id, int cantidad, Double precio_unitario ){
        Document producto= new Document("_id", id)
            .append("pedido_id", pedido_id)
            .append("producto_id", producto_id)
            .append("cantidad", cantidad)
            .append("precio_unitario", precio_unitario);
        collection.insertOne(producto);
    }
    
    public static void EditarDetallePedido(MongoCollection<Document> collection,String id, String pedido_id, String producto_id, int cantidad, Double precio_unitario){
        collection.updateOne(eq("_id",id), set("pedido_id", pedido_id));
        collection.updateOne(eq("_id",id), set("producto_id", producto_id));
        collection.updateOne(eq("_id",id), set("cantidad", cantidad));
        collection.updateOne(eq("_id",id), set("precio_unitario", precio_unitario));
    }
    
    public  static void EliminarDetallePedido(MongoCollection<Document> collection,String id){
        collection.deleteOne(eq("_id",id));
    }
    
    public static void MostrarDetallePedido(MongoCollection<Document> collection,String id){
         MongoCursor<Document> cursor = collection.find(eq("_id", id)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    //SEGUNDA PREGUNTA
    
    //Obtener los productos con un precio mayor a 20 dolares
    
    public static void obtenerProductosMayor20Dolares(MongoCollection<Document> collection){
         MongoCursor<Document> cursor = collection.find(gt("Precio", 20)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    //Obtener los pedidos que tengan un total mayor a 100 dolares
    
    public static void obtenerPedidosTotalMayorA100(MongoCollection<Document> collection){
         MongoCursor<Document> cursor = collection.find(gt("Total", 100)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    
    //Obtener los pedidos en donde exista un detalle de pedido con el producto010
    
    public static void obtenerPedidosConProducto010(MongoCollection<Document> collectionDetalles){
        MongoCursor<Document> cursor1 = collectionDetalles.find(eq("producto_id", "producto010")).iterator();
        while (cursor1.hasNext()) {
            System.out.println(cursor1.next().toJson());
        }
    }
    
    //TERCERA PREGUNTA
    //CRUD
    public static void crearEsquemaDesnormalizado(MongoCollection <Document> collectionEsquema, String id, String cliente, String nombre_cliente, String correo_cliente, String telefono_cliente, String direccion_cliente, String tipo_habitacion, int numero_habitacion, double precio_noche_habitacion, int capacidad_habitacion, String descripcion_habitacion, Date fecha_entrada, Date fecha_salida, double total, String estado_pago, String metodo_pago, Date fecha_reserva){
        Document esquema = new Document("_id",id)
                .append("cliente", 
                        new Document("nombre",nombre_cliente)
                                .append("correo",correo_cliente)
                                .append("telefono", telefono_cliente)
                                .append("direccion", direccion_cliente)
                .append("habitacion", 
                        new Document("tipo",tipo_habitacion)
                                .append("numero",numero_habitacion)
                                .append("precio_noche", precio_noche_habitacion)
                                .append("capacidad", capacidad_habitacion)
                                .append("descripcion", descripcion_habitacion))
                .append("fecha_entrada",fecha_entrada)
                .append("fecha_salida",fecha_salida)
                .append("total",total)
                .append("estado_pago",estado_pago)
                .append("metodo_pago",metodo_pago)
                .append("fecha_reserva",fecha_reserva));
        collectionEsquema.insertOne(esquema);
    }
    
    public static void editarEsquemaDesnormalizado(MongoCollection <Document> collectionEsquema, String id, String cliente){
        collectionEsquema.updateOne(eq("_id",id), set("cliente",cliente));
    }
    
    public static void eliminarEsquemaDesnormalizado(MongoCollection <Document> collectionEsquema, String id){
        collectionEsquema.deleteOne(eq("_id",id));
    }
    
    public static void mostrarEsquemaDesnormalizado(MongoCollection <Document> collectionEsquema, String id){
        MongoCursor<Document> cursor = collectionEsquema.find(eq("_id", id)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    //CUARTA PREGUNTA
    //Obtener las habitaciones reservadas de tipo “Sencilla”
    public static void mostrarEsquemaHabitacionSencilla (MongoCollection <Document> collectionEsquema){
        MongoCursor<Document> cursor = collectionEsquema.find(eq("habitacion.tipo", "Sencilla")).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
    
    //Obtener la sumatoria total de las reservas pagadas.
    public static void mostrarTotalReservasPagadas (MongoCollection <Document> collectionEsquema){
        MongoCursor<Document> cursor = collectionEsquema.find(eq("estado_pago", "Pagado")).iterator();
        int sumatoria = 0;
        while (cursor.hasNext()) {
            Document doc = cursor.next();
            sumatoria += doc.getDouble("total");
        }
        System.out.println("Sumatoria total de las reservas pagadas: " + sumatoria);
    }
    
    //Obtener las reservas de las habitaciones con un precio_noche mayor a 100 dolares.
    public static void reservasHabitacionesMayorA100 (MongoCollection <Document> collectionEsquema){
        MongoCursor<Document> cursor = collectionEsquema.find(gt("habitacion.precio_noche", 100)).iterator();
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }

    }
}
