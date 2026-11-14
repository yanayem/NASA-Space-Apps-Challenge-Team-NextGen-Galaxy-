import 'risk_models.dart';

class PresetSites {
  static const List<CandidateSite> sampleSites = [
    CandidateSite(
      id: 'site_dhaka',
      name: 'Dhaka Central Logistics Hub',
      latitude: 23.8103,
      longitude: 90.4125,
      region: 'Dhaka Division, Bangladesh',
      description: 'High-density commercial transportation corridor with urban heat and drainage considerations.',
    ),
    CandidateSite(
      id: 'site_ctg',
      name: 'Chittagong Port Infrastructure Gateway',
      latitude: 22.3569,
      longitude: 91.7832,
      region: 'Chittagong Division, Bangladesh',
      description: 'Strategic maritime logistics coastal location subject to tidal water changes.',
    ),
    CandidateSite(
      id: 'site_gazipur',
      name: 'Gazipur Industrial Solar Park',
      latitude: 23.9999,
      longitude: 90.4203,
      region: 'Gazipur, Bangladesh',
      description: 'Expansive land area optimized for utility-scale solar generation with high surface thermal trends.',
    ),
    CandidateSite(
      id: 'site_sylhet',
      name: 'Sylhet Hi-Tech Data Center',
      latitude: 24.8949,
      longitude: 91.8687,
      region: 'Sylhet, Bangladesh',
      description: 'Elevated tech zone site with seasonal rainfall exposure and stable geotechnical profile.',
    ),
    CandidateSite(
      id: 'site_khulna',
      name: 'Khulna Eco-Industrial Site',
      latitude: 22.8456,
      longitude: 89.5403,
      region: 'Khulna, Bangladesh',
      description: 'Southern river basin industrial expansion zone with aquatic index monitoring.',
    ),
  ];
}
