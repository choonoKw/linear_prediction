% HW04_com1.m

% load data
fileName = 'speech';
load([fileName,'.dat'])
x0 = speech;

%% 1) take the half for training and test
% measure
N = length(x0);
Nr = round(N/2);
Ne = N-Nr;

% allocate data
xr = x0(1:Nr);
xe = x0(Nr+1:end);

%% b) estimate correlation function and apply Levinson-Durbin
% derive autocorrelation
P=50;
rx = zeros(P+1,1);
for k=0:P
    temp = 0;
    for n=0:Nr-k-1
        temp = temp + xr(n+k +1)*xr(n +1);
    end
    rx(k +1) = temp/Nr; % biased-autocorr. p.8 of LN12
end

% Levinson-Durbin algorithm, ref: p.28 of LN 9
A = zeros(P+2,P+1);
mse_gamma = zeros(P +1,1);
mse_train = zeros(P +1,1);
% init:
a = [1 0]; var = rx(0 +1);
A(1:2,1) = a;
mse_gamma(1) = var;
mse_train(1) = var;
for k=0:P-1
    ak = a;
    
    alpha = 0;
    for l=0:k
        alpha = alpha + ak(l +1)*rx(k+1-l +1);
    end
    gamma = alpha/var;
    a = zeros(k+2 +1,1);
    a(0 +1) = 1;
    for l=1:k+1
        a(l +1) = ak(l +1)-gamma*ak(k+1-l +1);
    end
    var = var*(1-gamma^2);
    A(1:k+2 +1,k+1 +1) = a;
    mse_gamma(k+1 +1) = var;
    
    % direct error calculation
    e=zeros(Nr,1);
    p = k;
    for n=0:Nr-1
        e(n +1) = 0;
        for kk=0:min(p,n)
            e(n +1) = e(n +1) + ak(kk +1)*xe(n-kk +1);
        end
    end
    mse_train(k+1 +1) = e.'*e/Nr;
    xr_hat = conv(xr, -a(2:end));
    
%     figure(1); clf; hold on;
%     plot(xr,'k','LineWidth',2);
%     plot(xr_hat,'r--','LineWidth',2);
end

%% c) derive SSE of training data and plot w.r.t order of filter
figure(1); clf;
plot(1:P,mse_gamma(2:end),'r','LineWidth',2);
grid on;
xlabel('$p$','Interpreter','latex');
ylabel('$\sigma_e^2$','Interpreter','latex');
set(gca,'FontWeight','bold','LineWidth',2,'FontSize',14)

figure(2); clf;
plot(1:P,mse_train(2:end),'r','LineWidth',2);
grid on;
xlabel('$p$','Interpreter','latex');
ylabel('$\sigma_e^2$','Interpreter','latex');
set(gca,'FontWeight','bold','LineWidth',2,'FontSize',14)

%% d) calculate SSE of test data and plot
mse = zeros(P+1,1);
mse_test = zeros(P+1,1);
for p=0:P
    e=zeros(Ne,1);
    ak = A(1:p+1,p +1);
    for n=0:Ne-1
%         xe_hat = 0;
%         for k=1:min(p,n)
%             xe_hat = xe_hat - ak(k)*x(n-k +1);
%         end
        e(n +1) = 0;
        for k=0:min(p,n)
            e(n +1) = e(n +1) + ak(k +1)*xe(n-k +1);
        end
    end
%     e_conv = conv(xe,ak(end:-1:1));
    mse_test(p +1) = sum(e.^2)/Ne;
%     mse_test(p +1) = sum(e_conv.^2)/Ne;
end

figure(3); clf; hold on;
plot(1:P,mse_train(2:end),'b','LineWidth',2);
plot(1:P,mse_test(2:end),'r--','LineWidth',2);
% plot(1:P,mse(2:end),'g')
grid on;
xlabel('$p$','Interpreter','latex');
ylabel('$\sigma_e^2$','Interpreter','latex');
legend({'train','test'})
set(gca,'FontWeight','bold','LineWidth',2,'FontSize',14)


%% figure save
% orgLocation = pwd;
% cd(fullfile(orgLocation,fileName));
% print(1,'com1_training_mse_gamma','-djpeg');
% print(2,'com1_training_mse','-djpeg');
% print(3,'com1_mse_compare','-djpeg');
% cd(orgLocation);

%% e)For several p, plot predictions
p_list = [1 5 10 20 50];
p_num = length(p_list);
for p_index = 1:p_num
    p =p_list(p_index);
    ak = A(:,p+1);
    % prediction of training 
    xr_hat = zeros(Nr,1);
    for n=0:Nr-1
        xr_hat_n = 0;
        for k=1:min(p,n)
            xr_hat_n = xr_hat_n - ak(k +1)*xr(n-k +1);
        end
        xr_hat(n +1) = xr_hat_n;
    end
    % plot
    figure(4); clf; hold on;
    plot(0:Nr-1,xr,'k','LineWidth',2);
    plot(0:Nr-1,xr_hat,'r--','LineWidth',2);
    grid on;
    xlabel('$n$','Interpreter','latex'); ylabel('');
    legend({'$x_r$','$\hat{x_r}$'},'Interpreter','latex');
    set(gca,'FontWeight','bold','LineWidth',2)
    set(findall(gcf,'-property','FontSize'),'FontSize',14)
    
    % prediction of test
    xe_hat = zeros(Ne,1);
    for n=0:Ne-1
        xe_hat_n = 0;
        for k=1:min(p,n)
            xe_hat_n = xe_hat_n - ak(k +1)*xe(n-k +1);
        end
        xe_hat(n +1) = xe_hat_n;
    end
    % plot
    figure(5); clf; hold on;
    plot(0:Ne-1,xe,'k','LineWidth',2);
    plot(0:Ne-1,xe_hat,'r--','LineWidth',2);
    grid on;
    xlabel('$n$','Interpreter','latex'); ylabel('');
    legend({'$x_e$','$\hat{x_e}$'},'Interpreter','latex');
    set(gca,'FontWeight','bold','LineWidth',2)
    set(findall(gcf,'-property','FontSize'),'FontSize',14)
    
    % figure save
%     cd(fullfile(orgLocation,fileName));
%     print(4,['com1e_training_p',num2str(p)],'-djpeg');
%     print(5,['com1e_test_p',num2str(p)],'-djpeg');
%     cd(orgLocation);
end