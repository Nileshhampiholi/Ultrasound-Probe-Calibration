function pos_joint = mjoint(target_joints_angles)
global A D ALPHA;

for k=1:8
    for i=1:6
        theta_i=(target_joints_angles(i,k)/180)*pi;
        alpha_i= ALPHA(:,i);
        a_i = A(:,i);
        d_i = D (:,i);
        T_Matrix{i,k} =[cos(theta_i), -sin(theta_i)*cos(alpha_i), sin(theta_i)*sin(alpha_i), a_i*cos(theta_i);
            sin(theta_i), cos(theta_i)*cos(alpha_i), -cos(theta_i)*sin(alpha_i), a_i*sin(theta_i);
            0, sin(alpha_i), cos(alpha_i), d_i;
            0, 0, 0, 1];
    end
end

for k=1:8
    for i =1:6
        switch i
            case 1
                matrix_joint{i,k} = T_Matrix{1,k};
            case 2
                matrix_joint{i,k} = T_Matrix{1,k}*T_Matrix{2,k};
            case 3
                matrix_joint{i,k} = T_Matrix{1,k}*T_Matrix{2,k}*T_Matrix{3,k};
            case 4
                matrix_joint{i,k} = T_Matrix{1,k}*T_Matrix{2,k}*T_Matrix{3,k}*T_Matrix{4,k};
            case 5
                matrix_joint{i,k} = T_Matrix{1,k}*T_Matrix{2,k}*T_Matrix{3,k}*T_Matrix{4,k}*T_Matrix{5,k};
            case 6
                matrix_joint{i,k} = T_Matrix{1,k}*T_Matrix{2,k}*T_Matrix{3,k}*T_Matrix{4,k}*T_Matrix{5,k}*T_Matrix{6,k}
        end
    end
end

for i = 1:8
    for k=1:6
        pos_joint{k,i} = [matrix_joint{k,i}(1,4); matrix_joint{k,i}(2,4); matrix_joint{k,i}(3,4)];
    end
end

end