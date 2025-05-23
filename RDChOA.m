
function [Attacker_score,Attacker_pos,Convergence_curve]=myChimp(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
 
% initialize Attacker, Barrier, Chaser, and Driver
Attacker_pos=zeros(1,dim);
Attacker_score=inf; %change this to -inf for maximization problems
 
Barrier_pos=zeros(1,dim);
Barrier_score=inf; %change this to -inf for maximization problems
 
Chaser_pos=zeros(1,dim);
Chaser_score=inf; %change this to -inf for maximization problems
 
Driver_pos=zeros(1,dim);
Driver_score=inf; %change this to -inf for maximization problems
 
%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);

%Hammersley
H = Hammersley(dim+1,SearchAgents_no);
for i=1:SearchAgents_no
    % Positions(i, :)=H(i, dim:dim+1).*(ub-lb)+lb;
    Positions(i, :)=H(i, dim:dim+1).*(ub-lb)+lb;
end

 
Convergence_curve=zeros(1,Max_iter);
 
l=0;% Loop counter
%%
% Main loop
while l<Max_iter
    for i=1:size(Positions,1)  
        
       % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;               
        
        % Calculate objective function for each search agent
        fitness=fobj(Positions(i,:));
        
        % Update Attacker, Barrier, Chaser, and Driver
        if fitness<Attacker_score 
            Attacker_score=fitness; % Update Attacker
            Attacker_pos=Positions(i,:);
        end
        
        if fitness>Attacker_score && fitness<Barrier_score 
            Barrier_score=fitness; % Update Barrier
            Barrier_pos=Positions(i,:);
        end
        
        if fitness>Attacker_score && fitness>Barrier_score && fitness<Chaser_score 
            Chaser_score=fitness; % Update Chaser
            Chaser_pos=Positions(i,:);
        end
         if fitness>Attacker_score && fitness>Barrier_score && fitness>Chaser_score && fitness>Driver_score 
            Driver_score=fitness; % Update Driver
            Driver_pos=Positions(i,:);
        end
    end
    
    
    f=2-l*((2)/Max_iter); % a decreases linearly fron 2 to 0
    
    %  The Dynamic Coefficient of f Vector as Table 1.
    
    %Group 1
    C1G1=1.95-((2*l^(1/3))/(Max_iter^(1/3)));
    C2G1=(2*l^(1/3))/(Max_iter^(1/3))+0.5;
        
    %Group 2
    C1G2= 1.95-((2*l^(1/3))/(Max_iter^(1/3)));
    C2G2=(2*(l^3)/(Max_iter^3))+0.5;
    
    %Group 3
    C1G3=(-2*(l^3)/(Max_iter^3))+2.5;
    C2G3=(2*l^(1/3))/(Max_iter^(1/3))+0.5;
    
    %Group 4
    C1G4=(-2*(l^3)/(Max_iter^3))+2.5;
    C2G4=(2*(l^3)/(Max_iter^3))+0.5;

    %͸��������ѧϰ
    k_rand=rand(1,1);
    k = (1+k_rand*((2*l)/Max_iter)^(0.5))^9;
    new_Attacker_pos = (lb+ub)/2+(lb+ub)/(2*k)-Attacker_pos/k;
    Flag4ub = new_Attacker_pos > ub;
    Flag4lb = new_Attacker_pos < lb;
    new_Attacker_pos = (new_Attacker_pos.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
    if fobj(new_Attacker_pos) < Attacker_score
        Attacker_pos = new_Attacker_pos;
        Attacker_score = fobj(new_Attacker_pos);
    end

    % Update the Position of search agents including omegas
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
%               
%              
%% Please note that to choose a other groups you should use the related group strategies
            r11=C1G1*rand(); % r1 is a random number in [0,1]
            r12=C2G1*rand(); % r2 is a random number in [0,1]
            
            r21=C1G2*rand(); % r1 is a random number in [0,1]
            r22=C2G2*rand(); % r2 is a random number in [0,1]
            
            r31=C1G3*rand(); % r1 is a random number in [0,1]
            r32=C2G3*rand(); % r2 is a random number in [0,1]
            
            r41=C1G4*rand(); % r1 is a random number in [0,1]
            r42=C2G4*rand(); % r2 is a random number in [0,1]
            
            A1=2*f*r11-f; % Equation (3)
            C1=2*r12; % Equation (4)
           
%% % Please note that to choose various Chaotic maps you should use the related Chaotic maps strategies
            m=chaos(3,1,1); % Equation (5)
            D_Attacker=abs(C1*Attacker_pos(j)-m*Positions(i,j)); % Equation (6)
            X1=Attacker_pos(j)-A1*D_Attacker; % Equation (7)
                       
            A2=2*f*r21-f; % Equation (3)
            C2=2*r22; % Equation (4)
            
                   
            D_Barrier=abs(C2*Barrier_pos(j)-m*Positions(i,j)); % Equation (6)
            X2=Barrier_pos(j)-A2*D_Barrier; % Equation (7)     
            
        
            
            A3=2*f*r31-f; % Equation (3)
            C3=2*r32; % Equation (4)
            
            D_Driver=abs(C3*Chaser_pos(j)-m*Positions(i,j)); % Equation (6)
            X3=Chaser_pos(j)-A3*D_Driver; % Equation (7)      
            
            A4=2*f*r41-f; % Equation (3)
            C4=2*r42; % Equation (4)
            
            D_Driver=abs(C4*Driver_pos(j)-m*Positions(i,j)); % Equation (6)
            X4=Chaser_pos(j)-A4*D_Driver; % Equation (7)
            
            
            round_i=randi([1 i]);
            round_i=floor(round_i);
            round_j=randi([1 j]);
            round_j=floor(round_j);
            f1 = randn(1,1);
            f2 = randn(1,1);
            if i>(Max_iter/2) && j>(Max_iter/2)
                Positions(i,j)=f1*(X1-Positions(i,j-1))+f2*(Positions(round_i,round_j)-Positions(i,j-1));
            else
                Positions(i,j)=(X1+X2+X3+X4)/4;
                % Positions(i,j)=1./(W1+W2+W3+W4).*(W1.*X1+W2.*X2+W3.*X3+W4.*X4)/4;
            end  
        end
    end
    l=l+1;    
    Convergence_curve(l)=Attacker_score;
end
 
 
 


