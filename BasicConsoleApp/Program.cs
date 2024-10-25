CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();
CancellationToken cancellationToken = cancellationTokenSource.Token;

Console.CancelKeyPress += (sender, args) =>
{
    cancellationTokenSource.Cancel();
    args.Cancel = true;
};

Console.WriteLine("[PROGRAM START]");

while (!cancellationToken.IsCancellationRequested)
{
    Console.WriteLine("[{0:HH:mm:ss}] Ok", DateTime.UtcNow);
    Thread.Sleep(1000);
}

Console.WriteLine("[PROGRAM END]");