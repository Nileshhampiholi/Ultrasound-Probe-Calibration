function configuration = getStatus(self)
msg = self.sendReceive('GetStatus');
args = textscan(msg,'%s');
args = args{:}';
configuration = Configuration(char(args(1)),char(args(2)),char(args(3)));
end

