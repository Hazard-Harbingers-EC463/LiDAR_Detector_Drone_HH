import random
from itertools import count
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()


def animate(i):
    data = pd.read_csv('putty_log.txt')
    x = data['i']
    y1 = data['T']
    y2 = data['P']
    y3 = data['H']
    plt.cla()
    plt.plot(x[-50:-1], y2[-50 :-1], label='Pressure')
    plt.legend(loc='upper left')
    pl_ax = plt.gca()
    plt.tight_layout()


ani = FuncAnimation(plt.gcf(), animate, interval=1000)

plt.tight_layout()
plt.show()