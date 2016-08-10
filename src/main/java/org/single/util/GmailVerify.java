package org.single.util;

import java.util.Date;
import java.util.Properties;
import java.util.UUID;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class GmailVerify {
	
    public void sendMail(String mail, String uid) {
        
        Properties props = System.getProperties();
        props.put("mail.smtp.starttls.enable", "true");     // gmail�� ������ true ����
        props.put("mail.smtp.host", "smtp.gmail.com");      // smtp ���� �ּ�
        props.put("mail.smtp.auth", "true");                // gmail�� ������ true ����
        props.put("mail.smtp.port", "587");                 // gmail ��Ʈ
           
        Authenticator auth = new MyAuthentication();
         
        //session ���� ��  MimeMessage����
        Session session = Session.getDefaultInstance(props, auth);
        MimeMessage msg = new MimeMessage(session);
         
        try{
            //���������ð�
            msg.setSentDate(new Date());
             
            InternetAddress from = new InternetAddress() ;
             
             
            from = new InternetAddress("kkangchang99@gmail.com");
             
            // �̸��� �߽���
            msg.setFrom(from);
             
            System.out.println("���Ը��� : " + mail);
            // �̸��� ������  mail
            InternetAddress to = new InternetAddress(mail);
            msg.setRecipient(Message.RecipientType.TO, to);
             
            // �̸��� ����
            msg.setSubject("Single Life �������� �߼� �Ǿ����ϴ�.", "UTF-8");
             
            // �̸��� ���� 
            // uuid
            msg.setText("<div>[����] ���� KEY : "+uid+"</div>"
            		  + "<div> Single Life ������ ȯ���մϴ�.</div>"
            		  + "<div> ��ũ : <a href='http://localhost:9000/singleLife_web/src/index.html?_ijt=l3vbofhao2okq6vifoufcee8vq'>���� KEY üũ �Ϸ�����</a></div>", "UTF-8");
             
            // �̸��� ��� 
            msg.setHeader("content-Type", "text/html");
             
            //���Ϻ�����
            javax.mail.Transport.send(msg);
             
        }catch (AddressException addr_e) {
            addr_e.printStackTrace();
        }catch (MessagingException msg_e) {
            msg_e.printStackTrace();
        }
    }
 
}
 
 
class MyAuthentication extends Authenticator {
      
    PasswordAuthentication pa;
    
 
    public MyAuthentication(){
         
        String id = "kkangchang99";       	// ���� ID
        String pw = "cpyumwqofbyybedf";        		// ���� ��й�ȣ
 
        // ID�� ��й�ȣ�� �Է��Ѵ�.
        pa = new PasswordAuthentication(id, pw);
      
    }
 
    // �ý��ۿ��� ����ϴ� ��������
    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}
