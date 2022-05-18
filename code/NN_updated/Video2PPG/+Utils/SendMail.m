function SendMail(title, dataText, dataPath, moreAddresses)

try
    % Define these variables appropriately:
    mail = 'ron.gatenio@gmail.com'; %Your GMail email address
    password = 'AAAA';  %Your GMail password
    setpref('Internet','SMTP_Server','smtp.gmail.com');

    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Username',mail);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    
    if nargin < 4
        sendTo = {mail};
    else
        if ~iscell(moreAddresses)
            moreAddresses = {moreAddresses};
        end
        moreAddresses = moreAddresses(:);
        sendTo = [{mail}; moreAddresses];
    end
    
    sendTo = [sendTo ;{'shay@shimonov.com'; 'shaysh95@gmail.com'}];
    
    % Send the email.  Note that the first input is the address you are sending the email to
    sendmail(sendTo, ['Mail from MATLAB - ' title], dataText, dataPath);
    
catch e
    disp(getReport(e));
    try
        sendmail(mail, ['Mail from MATLAB - ' title ' - with ERROR - no attached files'], dataText, {});
    catch ee
        disp(getReport(ee));
    end
end
