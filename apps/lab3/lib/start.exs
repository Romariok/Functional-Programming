Code.require_file("args_parser.ex", __DIR__)
Code.require_file("calculator.ex", __DIR__)
Code.require_file("printer.ex", __DIR__)
Code.require_file("input_parser.ex", __DIR__)

opts = ArgsParser.parse_args(System.argv())

pid = Printer.start(opts)
calculator_pid = Calculator.start(pid, opts)
InputParser.start(calculator_pid)
