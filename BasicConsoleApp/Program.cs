CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();
CancellationToken cancellationToken = cancellationTokenSource.Token;

Console.CancelKeyPress += (_, args) =>
{
    cancellationTokenSource.Cancel();
    args.Cancel = true;
};

Console.WriteLine("[PROGRAM START]");

while (!cancellationToken.IsCancellationRequested)
{
    try
    {
        Console.WriteLine("[{0:HH:mm:ss}] Ok", DateTime.UtcNow);
        await Task.Delay(4000, cancellationTokenSource.Token);
    }
    catch (TaskCanceledException)
    {
        Console.WriteLine("[PROGRAM CANCELLED]");
    }
}

Console.WriteLine("[PROGRAM END]");