// villages.js

let villageDatabase = [];

async function loadVillages() {

  try {

    const response = await fetch("Karnataka_Villages.csv");

    if (!response.ok) {
      throw new Error("CSV file not found");
    }

    const csvText = await response.text();

    const rows = csvText.split(/\r?\n/);

    if (rows.length < 2) {
      console.error("CSV empty");
      return;
    }

    const headers = rows[0].split(",");

    const districtIndex =
      headers.findIndex(h =>
        h.trim().toLowerCase().includes("district")
      );

    const talukIndex =
      headers.findIndex(h =>
        h.trim().toLowerCase().includes("sub district")
      );

    const villageIndex =
      headers.findIndex(h =>
        h.trim().toLowerCase().includes("village")
      );

    const panchayatIndex =
      headers.findIndex(h =>
        h.trim().toLowerCase().includes("gram panchayat")
      );

    rows.slice(1).forEach(row => {

      if (!row.trim()) return;

      const cols = row.split(",");

      villageDatabase.push({

        district:
          cols[districtIndex]?.trim() || "",

        taluk:
          cols[talukIndex]?.trim() || "",

        village:
          cols[villageIndex]?.trim() || "",

        panchayat:
          cols[panchayatIndex]?.trim() || ""

      });

    });

    console.log(
      "Villages Loaded:",
      villageDatabase.length
    );

  } catch (err) {

    console.error(
      "Village Database Error:",
      err
    );

  }

}

loadVillages();
