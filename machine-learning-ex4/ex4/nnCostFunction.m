function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


bias = ones(m, 1);          % 5000 x 1

X = [bias X];          % 5000 x 401
z2 = X*Theta1';        % 5000 x 25
a2 = sigmoid(z2);      % 5000 x 25

a2 = [bias a2];         % 5000 x 26
z3 = a2*Theta2';        % 5000 x 10
h = sigmoid(z3);       % 5000 x 10

[newopvalue new_a2] = max(a2, [], 2); % 5000 x 1

new_y = zeros(size(h,1), size(h,2));  % 5000 x 10

for i=1:m
  new_y(i, y(i)) = 1;
endfor


for i=1:size(h,1)
  for j=1:size(h,2)
    J = J - (1/m)*(new_y(i,j)*log(h(i,j)) + (1-new_y(i,j))*log(1-h(i,j)));
  endfor
endfor

for i=1:size(Theta1,1)
  for j=2:size(Theta1,2)
    J = J + (lambda/(2*m))*(Theta1(i,j)^2);
  endfor
endfor

for i=1:size(Theta2,1)
  for j=2:size(Theta2,2)
    J = J + (lambda/(2*m))*(Theta2(i,j)^2);
  endfor
endfor

for i=1:m
  
  a1 = X(i,:);      % 1 x 401
  a1 = a1';         % 401 x 1
  z2 = Theta1*a1;   % (25 x 401) x (401 x 1)
  a2 = sigmoid(z2); % 25 x 1
  
  a2 = [1; a2];     % 26 x 1
  z3 = Theta2*a2;   % (10 x 26) x (26 x 1)
  a3 = sigmoid(z3); % 10 x 1
  
  y3 = new_y(i,:);  % 1 x 10
  y3 = y3';
  
  delta3 = a3 - y3; % 10 x 1
  
  z2 = [1; z2];     % 26 x 1
  
  delta2 = (Theta2' * delta3).*sigmoidGradient(z2); % (26 x 10) x (10 x 1)
  
  delta2 = delta2(2:end); % 25 x 1
    
  Theta2_grad = Theta2_grad + delta3*a2'; % (10 x 1) x (1 x 26)
  Theta1_grad = Theta1_grad + delta2*a1'; % (25 x 1) x (1 x 401)
  
endfor

Theta2_grad = (1/m)*Theta2_grad;
Theta1_grad = (1/m)*Theta1_grad;

for i=1:size(Theta1,1)
  for j=2:size(Theta1,2)
    Theta1_grad(i,j) = Theta1_grad(i,j) + (lambda/m)*Theta1(i,j);
  endfor
endfor

for i=1:size(Theta2,1)
  for j=2:size(Theta2,2)
    Theta2_grad(i,j) = Theta2_grad(i,j) + (lambda/m)*Theta2(i,j);
  endfor
endfor


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
