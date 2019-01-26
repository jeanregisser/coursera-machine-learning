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

% map number to [0 ... 1 (indice == number) ... 0]
mappedY = zeros(m, num_labels);
mappedY(sub2ind(size(mappedY), (1:m)', y)) = 1;

Theta1Reg = Theta1;
Theta1Reg(:, 1) = 0;
Theta2Reg = Theta2;
Theta2Reg(:, 1) = 0;

J = 1 / m * sum((sum(-mappedY .* log(hyp(Theta1, Theta2, X)) - (1 - mappedY) .* log(1 - hyp(Theta1, Theta2, X)), 2))) ...
  + lambda / (2 * m) * (sum(sum(Theta1Reg .^ 2, 2)) + sum(sum(Theta2Reg .^ 2, 2)));

D1 = 0;
D2 = 0;

for t = 1:m
  % step 1
  xt = X(t, :)';
  yt = mappedY(t, :)';

  a1 = [1; xt];
  z2 = Theta1 * a1;
  a2 = [1; sigmoid(z2)];
  z3 = Theta2 * a2;
  a3 = sigmoid(z3); 

  % step 2
  d3 = (a3 - yt);

  % step 3
  d2 = Theta2' * d3 .* [1; sigmoidGradient(z2)];

  % step 4
  D1 = D1 + d2(2:end) * a1';
  D2 = D2 + d3 * a2';
end

% step 5

Theta1_grad = 1 / m * D1 + lambda / m * Theta1Reg;
Theta2_grad = 1 / m * D2 + lambda / m * Theta2Reg;















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
