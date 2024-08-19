classdef BetterHandle < matlab.mixin.Copyable
    % create a "copy" method that performs a shallow copy,
    % which copies all non-object properties of the class   该类继承自MATLAB的matlab.mixin.Copyable类，表示可以被复制的对象。该类定义了一个名为"copy"的方法，用于执行浅复制（shallow copy）操作，该方法将复制类的所有非对象属性（non-object properties）。浅复制是一种对象复制方式，它只复制对象本身及其所有属性的值，但不复制属性所引用的对象。
end

