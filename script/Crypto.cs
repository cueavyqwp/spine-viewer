using System;
using System.IO.Hashing;
using Godot;

public class MersenneTwister
{
    private const int N = 624;
    private const int M = 397;
    private const uint MATRIX_A = 0x9908B0DF;
    private const uint UPPER_MASK = 0x80000000;
    private const uint LOWER_MASK = 0x7FFFFFFF;

    private uint[] mt;
    private int index;

    public MersenneTwister(uint seed)
    {
        mt = new uint[N];
        index = N;

        mt[0] = seed & 0xFFFFFFFF;
        for (int i = 1; i < N; i++)
        {
            mt[i] = (uint)((0x6C078965UL * (mt[i - 1] ^ (mt[i - 1] >> 30)) + (uint)i) & 0xFFFFFFFF);
        }
    }

    private void Twist()
    {
        for (int i = 0; i < N; i++)
        {
            uint y = (mt[i] & UPPER_MASK) + (mt[(i + 1) % N] & LOWER_MASK);
            mt[i] = mt[(i + M) % N] ^ (y >> 1);
            if ((y & 1) != 0)
            {
                mt[i] ^= MATRIX_A;
            }
        }
        index = 0;
    }

    public uint Next()
    {
        if (index >= N)
        {
            Twist();
        }

        uint y = mt[index];
        y ^= y >> 11;
        y ^= (y << 7) & 0x9D2C5680;
        y ^= (y << 15) & 0xEFC60000;
        y ^= y >> 18;

        index++;
        return y & 0xFFFFFFFF;
    }

    public byte[] NextLength(int length)
    {
        byte[] buffer = new byte[length];
        int pos = 0;

        while (pos < length)
        {
            uint value = Next() >> 1;  // 右移1位
            int chunk = Math.Min(4, length - pos);

            for (int j = 0; j < chunk; j++)
            {
                buffer[pos + j] = (byte)((value >> (8 * j)) & 0xFF);
            }
            pos += chunk;
        }

        return buffer;
    }
}
static class Crypto
{
    public static string GetZipPassWord(string name)
    {
        var mt = new MersenneTwister(XxHash32.HashToUInt32(name.ToUtf8Buffer()));
        var buffer = mt.NextLength(15);
        return Convert.ToBase64String(buffer);
    }
}