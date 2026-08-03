package model;
import java.io.Serializable; import java.time.LocalDateTime; import java.util.*;
public class Order implements Serializable {
    private int id,userId; private String customer,address,phone,payment,status="PENDING"; private LocalDateTime created=LocalDateTime.now();
    private final Map<Integer,Integer> items=new LinkedHashMap<>(); private final Map<Integer,Long> prices=new LinkedHashMap<>(); private final List<String> history=new ArrayList<>(); private String note=""; private long total;
    public Order(int id,int userId,String customer,String address,String phone,String payment){this.id=id;this.userId=userId;this.customer=customer;this.address=address;this.phone=phone;this.payment=payment;}
    public int getId(){return id;} public int getUserId(){return userId;} public String getCustomer(){return customer;} public String getAddress(){return address;} public String getPhone(){return phone;} public String getPayment(){return payment;}
    public String getStatus(){return status;} public void setStatus(String v){status=v;history.add(LocalDateTime.now()+" - "+v);} public LocalDateTime getCreated(){return created;} public Map<Integer,Integer> getItems(){return items;} public Map<Integer,Long> getPrices(){return prices;} public List<String> getHistory(){return history;} public String getNote(){return note;} public void setNote(String v){note=v;} public long getTotal(){return total;} public void setTotal(long v){total=v;}
}
